// AFURLConnectionOperation.m
// Copyright (c) 2011–2015 Alamofire Software Foundation (http://alamofire.org/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFURLConnectionOperation.h"

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import <UIKit/UIKit.h>
#endif

#if !__has_feature(objc_arc)
#error AFNetworking must be built with ARC.
// You can turn on ARC for only AFNetworking files by adding -fobjc-arc to the build phase for each of its files.
#endif

typedef NS_ENUM(NSInteger, AFOperationState) {
    AFOperationPausedState      = -1,
    AFOperationReadyState       = 1,
    AFOperationExecutingState   = 2,
    AFOperationFinishedState    = 3,
};

static dispatch_group_t url_request_operation_completion_group() {
    static dispatch_group_t af_url_request_operation_completion_group;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        af_url_request_operation_completion_group = dispatch_group_create();
    });

    return af_url_request_operation_completion_group;
}

static dispatch_queue_t url_request_operation_completion_queue() {
    static dispatch_queue_t af_url_request_operation_completion_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        af_url_request_operation_completion_queue = dispatch_queue_create("com.alamofire.networking.operation.queue", DISPATCH_QUEUE_CONCURRENT );
    });

    return af_url_request_operation_completion_queue;
}

static NSString * const kAFNetworkingLockName = @"com.alamofire.networking.operation.lock";

NSString * const AFNetworkingOperationDidStartNotification = @"com.alamofire.networking.operation.start";
NSString * const AFNetworkingOperationDidFinishNotification = @"com.alamofire.networking.operation.finish";

typedef void (^AFURLConnectionOperationProgressBlock)(NSUInteger bytes, long long totalBytes, long long totalBytesExpected);
typedef void (^AFURLConnectionOperationAuthenticationChallengeBlock)(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge);
typedef NSCachedURLResponse * (^AFURLConnectionOperationCacheResponseBlock)(NSURLConnection *connection, NSCachedURLResponse *cachedResponse);
typedef NSURLRequest * (^AFURLConnectionOperationRedirectResponseBlock)(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse);
typedef void (^AFURLConnectionOperationBackgroundTaskCleanupBlock)();
///////////////状态机相关//////////////
static inline NSString * AFKeyPathFromOperationState(AFOperationState state) {
    //内部使用的枚举类型转成NSOperation使用的keyPath
    switch (state) {
        case AFOperationReadyState:
            return @"isReady";
        case AFOperationExecutingState:
            return @"isExecuting";
        case AFOperationFinishedState:
            return @"isFinished";
        case AFOperationPausedState:
            return @"isPaused";
        default: {
            //暂不明白为什么要加这部分，理论上不会走到这里
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
            return @"state";
#pragma clang diagnostic pop
        }
    }
}

static inline BOOL AFStateTransitionIsValid(AFOperationState fromState, AFOperationState toState, BOOL isCancelled) {
    //规定可以从哪些状态切换到哪些状态
    switch (fromState) {
        case AFOperationReadyState:
            switch (toState) {
                case AFOperationPausedState:
                case AFOperationExecutingState:
                    return YES;
                case AFOperationFinishedState:
                    return isCancelled;
                default:
                    return NO;
            }
        case AFOperationExecutingState:
            switch (toState) {
                case AFOperationPausedState:
                case AFOperationFinishedState:
                    return YES;
                default:
                    return NO;
            }
        case AFOperationFinishedState:
            return NO;
        case AFOperationPausedState:
            return toState == AFOperationReadyState;
        default: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
            switch (toState) {
                case AFOperationPausedState:
                case AFOperationReadyState:
                case AFOperationExecutingState:
                case AFOperationFinishedState:
                    return YES;
                default:
                    return NO;
            }
        }
#pragma clang diagnostic pop
    }
}

@interface AFURLConnectionOperation ()
@property (readwrite, nonatomic, assign) AFOperationState state;
@property (readwrite, nonatomic, strong) NSRecursiveLock *lock;
@property (readwrite, nonatomic, strong) NSURLConnection *connection;
@property (readwrite, nonatomic, strong) NSURLRequest *request;
@property (readwrite, nonatomic, strong) NSURLResponse *response;
@property (readwrite, nonatomic, strong) NSError *error;
@property (readwrite, nonatomic, strong) NSData *responseData;
@property (readwrite, nonatomic, copy) NSString *responseString;
@property (readwrite, nonatomic, assign) NSStringEncoding responseStringEncoding;
@property (readwrite, nonatomic, assign) long long totalBytesRead;
@property (readwrite, nonatomic, copy) AFURLConnectionOperationBackgroundTaskCleanupBlock backgroundTaskCleanup;
@property (readwrite, nonatomic, copy) AFURLConnectionOperationProgressBlock uploadProgress;
@property (readwrite, nonatomic, copy) AFURLConnectionOperationProgressBlock downloadProgress;
@property (readwrite, nonatomic, copy) AFURLConnectionOperationAuthenticationChallengeBlock authenticationChallenge;
@property (readwrite, nonatomic, copy) AFURLConnectionOperationCacheResponseBlock cacheResponse;
@property (readwrite, nonatomic, copy) AFURLConnectionOperationRedirectResponseBlock redirectResponse;

- (void)operationDidStart;
- (void)finish;
- (void)cancelConnection;
@end

@implementation AFURLConnectionOperation
@synthesize outputStream = _outputStream;
//AFNetworking线程的主体，处理NSURLConnection回调的专用线程
+ (void)networkRequestThreadEntryPoint:(id)__unused object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"AFNetworking"];
        //给线程创建一个Runloop，永不退出。
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        //因为不是主线程，mode是NSDefaultRunLoopMode也没关系
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

+ (NSThread *)networkRequestThread {
    //获取AFNetworking线程，单例模式，dispatch_once是生成单例的常见模式，确保线程安全
    static NSThread *_networkRequestThread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
        [_networkRequestThread start];
    });

    return _networkRequestThread;
}

- (instancetype)initWithRequest:(NSURLRequest *)urlRequest {
    NSParameterAssert(urlRequest);

    self = [super init];
    if (!self) {
		return nil;
    }

    _state = AFOperationReadyState;

    self.lock = [[NSRecursiveLock alloc] init];
    self.lock.name = kAFNetworkingLockName;

    self.runLoopModes = [NSSet setWithObject:NSRunLoopCommonModes];

    self.request = urlRequest;

    self.shouldUseCredentialStorage = YES;

    self.securityPolicy = [AFSecurityPolicy defaultPolicy];

    return self;
}

- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}

- (void)dealloc {
    if (_outputStream) {
        [_outputStream close];
        _outputStream = nil;
    }
    //APP在后台，任务在后台运行，需要告诉系统任务已完成，不然系统会一直让APP运行在后台，直到超时。
    if (_backgroundTaskCleanup) {
        _backgroundTaskCleanup();
    }
}

#pragma mark -

- (void)setResponseData:(NSData *)responseData {
    [self.lock lock];
    if (!responseData) {
        _responseData = nil;
    } else {
        _responseData = [NSData dataWithBytes:responseData.bytes length:responseData.length];
    }
    [self.lock unlock];
}

- (NSString *)responseString {
    [self.lock lock];
    //第一次访问才生成数据
    if (!_responseString && self.response && self.responseData) {
        self.responseString = [[NSString alloc] initWithData:self.responseData encoding:self.responseStringEncoding];
    }
    [self.lock unlock];

    return _responseString;
}

- (NSStringEncoding)responseStringEncoding {
    [self.lock lock];
    if (!_responseStringEncoding && self.response) {
        //同样第一次访问才生成数据
        //默认是UTF8编码
        NSStringEncoding stringEncoding = NSUTF8StringEncoding;
        //若NSHTTPURLResponse解析到返回的HTTP头部带上了编码类型，就用这个编码类型
        if (self.response.textEncodingName) {
            CFStringEncoding IANAEncoding = CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)self.response.textEncodingName);
            if (IANAEncoding != kCFStringEncodingInvalidId) {
                stringEncoding = CFStringConvertEncodingToNSStringEncoding(IANAEncoding);
            }
        }

        self.responseStringEncoding = stringEncoding;
    }
    [self.lock unlock];

    return _responseStringEncoding;
}

- (NSInputStream *)inputStream {
    return self.request.HTTPBodyStream;
}

- (void)setInputStream:(NSInputStream *)inputStream {
    NSMutableURLRequest *mutableRequest = [self.request mutableCopy];
    mutableRequest.HTTPBodyStream = inputStream;
    self.request = mutableRequest;
}

- (NSOutputStream *)outputStream {
    //默认的outputStream是保存到memory的，下载大文件有撑爆内存的风险
    //所以下载大文件需要自己调下面的setOutputStream设保存到文件的outputStream
    if (!_outputStream) {
        self.outputStream = [NSOutputStream outputStreamToMemory];
    }

    return _outputStream;
}

- (void)setOutputStream:(NSOutputStream *)outputStream {
    [self.lock lock];
    if (outputStream != _outputStream) {
        if (_outputStream) {
            [_outputStream close];
        }

        _outputStream = outputStream;
    }
    [self.lock unlock];
}

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
//APP退出到后台时继续发送接收请求
- (void)setShouldExecuteAsBackgroundTaskWithExpirationHandler:(void (^)(void))handler {
    //这个是外部接口，又读写了成员backgroundTaskCleanup，所以要加锁
    [self.lock lock];
    if (!self.backgroundTaskCleanup) {
        UIApplication *application = [UIApplication sharedApplication];
        UIBackgroundTaskIdentifier __block backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        __weak __typeof(self)weakSelf = self;
        
        self.backgroundTaskCleanup = ^(){
            if (backgroundTaskIdentifier != UIBackgroundTaskInvalid) {
                [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskIdentifier];
                backgroundTaskIdentifier = UIBackgroundTaskInvalid;
            }
        };
        //一个任务一个identifier，用于调用endBackgroundTask
        backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            //后台执行超时，APP将要休眠时会调用这个block
            //这个strongSelf应该是没必要的，就算block执行过程中self被释放也没什么问题。
            //何况下面使用strongSelf时还加了判断
            if (handler) {
                handler();
            }

            if (strongSelf) {
                [strongSelf cancel];
                strongSelf.backgroundTaskCleanup();
            }
        }];
    }
    [self.lock unlock];
}
#endif

#pragma mark -
/////////////////状态机相关/////////////////
- (void)setState:(AFOperationState)state {
    if (!AFStateTransitionIsValid(self.state, state, [self isCancelled])) {
        return;
    }

    [self.lock lock];
    NSString *oldStateKey = AFKeyPathFromOperationState(self.state);
    NSString *newStateKey = AFKeyPathFromOperationState(state);
    //切换状态时，旧状态和新状态都需要发KVO通知。
    //例如从isPaused切到isExecuting，需要让外部知道isPaused从YES变NO，isExecuting从NO变YES
    [self willChangeValueForKey:newStateKey];
    [self willChangeValueForKey:oldStateKey];
    _state = state;
    [self didChangeValueForKey:oldStateKey];
    [self didChangeValueForKey:newStateKey];
    [self.lock unlock];
}

- (void)pause {
    if ([self isPaused] || [self isFinished] || [self isCancelled]) {
        return;
    }

    [self.lock lock];
    if ([self isExecuting]) {
        [self performSelector:@selector(operationDidPause) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
        //统一规则：notification都在主线程发出
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:AFNetworkingOperationDidFinishNotification object:self];
        });
    }

    self.state = AFOperationPausedState;
    [self.lock unlock];
}

- (void)operationDidPause {
    [self.lock lock];
    [self.connection cancel];
    [self.lock unlock];
}

- (BOOL)isPaused {
    return self.state == AFOperationPausedState;
}

- (void)resume {
    if (![self isPaused]) {
        return;
    }

    [self.lock lock];
    self.state = AFOperationReadyState;

    [self start];
    [self.lock unlock];
}

#pragma mark -

- (void)setUploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block {
    self.uploadProgress = block;
}

- (void)setDownloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))block {
    self.downloadProgress = block;
}

- (void)setWillSendRequestForAuthenticationChallengeBlock:(void (^)(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge))block {
    self.authenticationChallenge = block;
}

- (void)setCacheResponseBlock:(NSCachedURLResponse * (^)(NSURLConnection *connection, NSCachedURLResponse *cachedResponse))block {
    self.cacheResponse = block;
}

- (void)setRedirectResponseBlock:(NSURLRequest * (^)(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse))block {
    self.redirectResponse = block;
}

#pragma mark - NSOperation

- (void)setCompletionBlock:(void (^)(void))block {
    [self.lock lock];
    if (!block) {
        //用于把block置nil消除循环引用
        [super setCompletionBlock:nil];
    } else {
        __weak __typeof(self)weakSelf = self;
        [super setCompletionBlock:^ {
            __strong __typeof(weakSelf)strongSelf = weakSelf;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_group_t group = strongSelf.completionGroup ?: url_request_operation_completion_group();
            dispatch_queue_t queue = strongSelf.completionQueue ?: dispatch_get_main_queue();
#pragma clang diagnostic pop
            //让传进来的completionBlock在一个group里执行，目前不清楚这样做的意义
            //若外部使用要把一堆请求放在一个group里，这里也不需要让completionBlock在这个group里执行
            //详见batchOfRequestOperations的实现
            dispatch_group_async(group, queue, ^{
                block();
            });
            //这里在url_request_operation_completion_queue()释放block在iOS5以下可能会导致"The Deallocation Problem"
            //但AFNetworking2.0只支持iOS6+，所以没问题
            //但还是不清除这里为什么专门用一条线程去释放completionBlock
            dispatch_group_notify(group, url_request_operation_completion_queue(), ^{
                [strongSelf setCompletionBlock:nil];
            });
        }];
    }
    [self.lock unlock];
}

- (BOOL)isReady {
    return self.state == AFOperationReadyState && [super isReady];
}

- (BOOL)isExecuting {
    return self.state == AFOperationExecutingState;
}

- (BOOL)isFinished {
    return self.state == AFOperationFinishedState;
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)start {
    //start是公开方法，可以在外部被任意线程调用，因为这里要修改self.state，加锁保证线程安全
    [self.lock lock];
    if ([self isCancelled]) {
        [self performSelector:@selector(cancelConnection) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
    } else if ([self isReady]) {
        self.state = AFOperationExecutingState;
        //在AFNetworking线程上执行这个任务
        [self performSelector:@selector(operationDidStart) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
    }
    [self.lock unlock];
}

- (void)operationDidStart {
    [self.lock lock];
    if (![self isCancelled]) {
        self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
        //在当前Runloop加上对connection和outputStream事件的侦听，回调就会在当前线程（AFNetworking）执行
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        for (NSString *runLoopMode in self.runLoopModes) {
            [self.connection scheduleInRunLoop:runLoop forMode:runLoopMode];
            [self.outputStream scheduleInRunLoop:runLoop forMode:runLoopMode];
        }

        [self.outputStream open];
        [self.connection start];
    }
    [self.lock unlock];

    dispatch_async(dispatch_get_main_queue(), ^{
        //统一规则：notification都在主线程发出
        [[NSNotificationCenter defaultCenter] postNotificationName:AFNetworkingOperationDidStartNotification object:self];
    });
}

- (void)finish {
    [self.lock lock];
    //在setState方法里会发出KVO通知，NSOperationQueue接收到finished的通知就会把当前任务释放了
    self.state = AFOperationFinishedState;
    [self.lock unlock];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:AFNetworkingOperationDidFinishNotification object:self];
    });
}

- (void)cancel {
    [self.lock lock];
    if (![self isFinished] && ![self isCancelled]) {
        [super cancel];

        if ([self isExecuting]) {
            [self performSelector:@selector(cancelConnection) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
        }
    }
    [self.lock unlock];
}

- (void)cancelConnection {
    NSDictionary *userInfo = nil;
    if ([self.request URL]) {
        userInfo = @{NSURLErrorFailingURLErrorKey : [self.request URL]};
    }
    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:userInfo];

    if (![self isFinished]) {
        if (self.connection) {
            [self.connection cancel];
            [self performSelector:@selector(connection:didFailWithError:) withObject:self.connection withObject:error];
        } else {
            // Accommodate race condition where `self.connection` has not yet been set before cancellation
            //start和cancel可能在外部由不同线程调用，有可能出现cancel在start前执行，这时self.connection还没构建
            self.error = error;
            [self finish];
        }
    }
}

#pragma mark -
//工具方法，传入一组请求，在所有请求完成后回调complionBlock
+ (NSArray *)batchOfRequestOperations:(NSArray *)operations
                        progressBlock:(void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
                      completionBlock:(void (^)(NSArray *operations))completionBlock
{
    if (!operations || [operations count] == 0) {
        //传个空数组进来，直接构建个回调completionBlock的NSOperation
        return @[[NSBlockOperation blockOperationWithBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(@[]);
                }
            });
        }]];
    }

    __block dispatch_group_t group = dispatch_group_create();
    NSBlockOperation *batchedOperation = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            //group所有任务完成后执行completionBlock
            if (completionBlock) {
                completionBlock(operations);
            }
        });
    }];

    for (AFURLConnectionOperation *operation in operations) {
        operation.completionGroup = group;
        void (^originalCompletionBlock)(void) = [operation.completionBlock copy];
        __weak __typeof(operation)weakOperation = operation;
        //在completionBlock加上progressBlock的回调，调用dispatch_group_leave通知group任务完成。
        operation.completionBlock = ^{
            __strong __typeof(weakOperation)strongOperation = weakOperation;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_queue_t queue = strongOperation.completionQueue ?: dispatch_get_main_queue();
#pragma clang diagnostic pop
            dispatch_group_async(group, queue, ^{
                //执行原来的completionBlock
                if (originalCompletionBlock) {
                    originalCompletionBlock();
                }
                //获取已完成的任务数，回调progressBlock
                NSUInteger numberOfFinishedOperations = [[operations indexesOfObjectsPassingTest:^BOOL(id op, NSUInteger __unused idx,  BOOL __unused *stop) {
                    return [op isFinished];
                }] count];

                if (progressBlock) {
                    progressBlock(numberOfFinishedOperations, [operations count]);
                }
                //请求完成，结束group任务，group任务数-1，最后一个请求完成时就会调用上面dispatch_group_notify里的completionBlock啦
                dispatch_group_leave(group);
            });
        };
        //开始group任务，group任务数+1，个人感觉这个dispatch_group_enter写在上面更好看。
        dispatch_group_enter(group);
        //添加依赖，执行完每一个operation后再执行batchedOperation
        //若operation里的实现是同步的，一个operation一个线程的话，用addDependency就可以解决所有请求完成后回调completionBlock的需求
        //但这里operation的实现是异步的，执行完operation只是构建好请求任务，所以还需借助dispatch_group才能知道所有请求完成的消息。
        [batchedOperation addDependency:operation];
    }

    return [operations arrayByAddingObject:batchedOperation];
}

#pragma mark - NSObject

- (NSString *)description {
    //直接用NSLog打这个对象出来时显示的内容
    [self.lock lock];
    NSString *description = [NSString stringWithFormat:@"<%@: %p, state: %@, cancelled: %@ request: %@, response: %@>", NSStringFromClass([self class]), self, AFKeyPathFromOperationState(self.state), ([self isCancelled] ? @"YES" : @"NO"), self.request, self.response];
    [self.lock unlock];
    return description;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection
willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if (self.authenticationChallenge) {
        self.authenticationChallenge(connection, challenge);
        return;
    }

    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([self.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
        } else {
            [[challenge sender] cancelAuthenticationChallenge:challenge];
        }
    } else {
        if ([challenge previousFailureCount] == 0) {
            if (self.credential) {
                [[challenge sender] useCredential:self.credential forAuthenticationChallenge:challenge];
            } else {
                [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
            }
        } else {
            [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
    }
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection __unused *)connection {
    return self.shouldUseCredentialStorage;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse
{
    if (self.redirectResponse) {
        //非主线程回调，因为要返回NSURLRequest，使用时得注意
        return self.redirectResponse(connection, request, redirectResponse);
    } else {
        return request;
    }
}

- (void)connection:(NSURLConnection __unused *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.uploadProgress) {
            self.uploadProgress((NSUInteger)bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        }
    });
}

- (void)connection:(NSURLConnection __unused *)connection
didReceiveResponse:(NSURLResponse *)response
{
    //开始接收数据
    self.response = response;
}

- (void)connection:(NSURLConnection __unused *)connection
    didReceiveData:(NSData *)data
{
    NSUInteger length = [data length];
    while (YES) {
        NSInteger totalNumberOfBytesWritten = 0;
        if ([self.outputStream hasSpaceAvailable]) {
            const uint8_t *dataBuffer = (uint8_t *)[data bytes];

            NSInteger numberOfBytesWritten = 0;
            while (totalNumberOfBytesWritten < (NSInteger)length) {
                //循环写数据到outputStream，直到全部写完或者出错
                numberOfBytesWritten = [self.outputStream write:&dataBuffer[(NSUInteger)totalNumberOfBytesWritten] maxLength:(length - (NSUInteger)totalNumberOfBytesWritten)];
                if (numberOfBytesWritten == -1) {
                    break;
                }

                totalNumberOfBytesWritten += numberOfBytesWritten;
            }

            break;
        } else {
            [self.connection cancel];
            if (self.outputStream.streamError) {
                [self performSelector:@selector(connection:didFailWithError:) withObject:self.connection withObject:self.outputStream.streamError];
            }
            return;
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        self.totalBytesRead += (long long)length;

        if (self.downloadProgress) {
            self.downloadProgress(length, self.totalBytesRead, self.response.expectedContentLength);
        }
    });
}

- (void)connectionDidFinishLoading:(NSURLConnection __unused *)connection {
    self.responseData = [self.outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];

    [self.outputStream close];
    if (self.responseData) {
        //解析完数据释放outputStream
       self.outputStream = nil;
    }

    self.connection = nil;

    [self finish];
}

- (void)connection:(NSURLConnection __unused *)connection
  didFailWithError:(NSError *)error
{
    self.error = error;

    [self.outputStream close];
    if (self.responseData) {
        self.outputStream = nil;
    }

    self.connection = nil;

    [self finish];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    if (self.cacheResponse) {
        //非主线程回调，因为要返回NSCachedURLResponse，使用时得注意
        return self.cacheResponse(connection, cachedResponse);
    } else {
        if ([self isCancelled]) {
            return nil;
        }

        return cachedResponse;
    }
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    //表明实现NSSecureCoding接口
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    //使用-decodeObjectOfClass:forKey:安全解析数据，NSSecureCoding的一部分。
    NSURLRequest *request = [decoder decodeObjectOfClass:[NSURLRequest class] forKey:NSStringFromSelector(@selector(request))];

    self = [self initWithRequest:request];
    if (!self) {
        return nil;
    }

    self.state = (AFOperationState)[[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(state))] integerValue];
    self.response = [decoder decodeObjectOfClass:[NSHTTPURLResponse class] forKey:NSStringFromSelector(@selector(response))];
    self.error = [decoder decodeObjectOfClass:[NSError class] forKey:NSStringFromSelector(@selector(error))];
    self.responseData = [decoder decodeObjectOfClass:[NSData class] forKey:NSStringFromSelector(@selector(responseData))];
    self.totalBytesRead = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(totalBytesRead))] longLongValue];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [self pause];

    [coder encodeObject:self.request forKey:NSStringFromSelector(@selector(request))];

    switch (self.state) {
        case AFOperationExecutingState:
        case AFOperationPausedState:
            [coder encodeInteger:AFOperationReadyState forKey:NSStringFromSelector(@selector(state))];
            break;
        default:
            [coder encodeInteger:self.state forKey:NSStringFromSelector(@selector(state))];
            break;
    }

    [coder encodeObject:self.response forKey:NSStringFromSelector(@selector(response))];
    [coder encodeObject:self.error forKey:NSStringFromSelector(@selector(error))];
    [coder encodeObject:self.responseData forKey:NSStringFromSelector(@selector(responseData))];
    [coder encodeInt64:self.totalBytesRead forKey:NSStringFromSelector(@selector(totalBytesRead))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFURLConnectionOperation *operation = [(AFURLConnectionOperation *)[[self class] allocWithZone:zone] initWithRequest:self.request];

    operation.uploadProgress = self.uploadProgress;
    operation.downloadProgress = self.downloadProgress;
    operation.authenticationChallenge = self.authenticationChallenge;
    operation.cacheResponse = self.cacheResponse;
    operation.redirectResponse = self.redirectResponse;
    operation.completionQueue = self.completionQueue;
    operation.completionGroup = self.completionGroup;

    return operation;
}

@end
