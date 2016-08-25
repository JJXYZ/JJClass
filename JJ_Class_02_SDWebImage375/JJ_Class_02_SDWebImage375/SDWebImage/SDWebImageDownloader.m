/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageDownloader.h"
#import "SDWebImageDownloaderOperation.h"
#import <ImageIO/ImageIO.h>

static NSString *const kProgressCallbackKey = @"progress";
static NSString *const kCompletedCallbackKey = @"completed";

@interface SDWebImageDownloader ()
/**
 *  SDWebImageDownloader 下载管理器是一个单例类，它主要负责图片的下载操作的管理。图片的下载是放在一个 NSOperationQueue 操作队列中来完成的，其声明如下：
 */
@property (strong, nonatomic) NSOperationQueue *downloadQueue;
@property (weak, nonatomic) NSOperation *lastAddedOperation;
@property (assign, nonatomic) Class operationClass;
@property (strong, nonatomic) NSMutableDictionary *URLCallbacks;
@property (strong, nonatomic) NSMutableDictionary *HTTPHeaders;
// This queue is used to serialize the handling of the network responses of all the download operation in a single queue
/**
 *  所有下载操作的网络响应序列化处理是放在一个自定义的并行调度队列中来处理的，其声明及定义如下：
 */
@property (SDDispatchQueueSetterSementics, nonatomic) dispatch_queue_t barrierQueue;

@end

@implementation SDWebImageDownloader

+ (void)initialize {
    // Bind SDNetworkActivityIndicator if available (download it here: http://github.com/rs/SDNetworkActivityIndicator )
    // To use it, just add #import "SDNetworkActivityIndicator.h" in addition to the SDWebImage import
    if (NSClassFromString(@"SDNetworkActivityIndicator")) {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id activityIndicator = [NSClassFromString(@"SDNetworkActivityIndicator") performSelector:NSSelectorFromString(@"sharedActivityIndicator")];
#pragma clang diagnostic pop

        // Remove observer in case it was previously added.
        [[NSNotificationCenter defaultCenter] removeObserver:activityIndicator name:SDWebImageDownloadStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:activityIndicator name:SDWebImageDownloadStopNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:activityIndicator
                                                 selector:NSSelectorFromString(@"startActivity")
                                                     name:SDWebImageDownloadStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:activityIndicator
                                                 selector:NSSelectorFromString(@"stopActivity")
                                                     name:SDWebImageDownloadStopNotification object:nil];
    }
}

+ (SDWebImageDownloader *)sharedDownloader {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (id)init {
    if ((self = [super init])) {
        _operationClass = [SDWebImageDownloaderOperation class];
        _shouldDecompressImages = YES;
        _executionOrder = SDWebImageDownloaderFIFOExecutionOrder;
        _downloadQueue = [NSOperationQueue new];
        _downloadQueue.maxConcurrentOperationCount = 6;
        _URLCallbacks = [NSMutableDictionary new];
#ifdef SD_WEBP
        _HTTPHeaders = [@{@"Accept": @"image/webp,image/*;q=0.8"} mutableCopy];
#else
        _HTTPHeaders = [@{@"Accept": @"image/*;q=0.8"} mutableCopy];
#endif
        _barrierQueue = dispatch_queue_create("com.hackemist.SDWebImageDownloaderBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        _downloadTimeout = 15.0;
    }
    return self;
}

- (void)dealloc {
    [self.downloadQueue cancelAllOperations];
    SDDispatchQueueRelease(_barrierQueue);
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    if (value) {
        self.HTTPHeaders[field] = value;
    }
    else {
        [self.HTTPHeaders removeObjectForKey:field];
    }
}

- (NSString *)valueForHTTPHeaderField:(NSString *)field {
    return self.HTTPHeaders[field];
}

- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrentDownloads {
    _downloadQueue.maxConcurrentOperationCount = maxConcurrentDownloads;
}

- (NSUInteger)currentDownloadCount {
    return _downloadQueue.operationCount;
}

- (NSInteger)maxConcurrentDownloads {
    return _downloadQueue.maxConcurrentOperationCount;
}

- (void)setOperationClass:(Class)operationClass {
    _operationClass = operationClass ?: [SDWebImageDownloaderOperation class];
}

/**
 *  整个下载管理器对于下载请求的管理都是放在 downloadImageWithURL:options:progress:completed: 方法里面来处理的，而该方法又调用了 addProgressCallback:andCompletedBlock:forURL:createCallback: 方法来将请求的信息存入管理器中，同时在创建回调的 block 中创建新的操作，配置之后将其放入 downloadQueue 操作队列中，最后方法返回新创建的操作，具体实现如下：
 */
- (id <SDWebImageOperation>)downloadImageWithURL:(NSURL *)url options:(SDWebImageDownloaderOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageDownloaderCompletedBlock)completedBlock {
    __block SDWebImageDownloaderOperation *operation;
    __weak __typeof(self)wself = self;

    //这里面都是创建下载的回调
    [self addProgressCallback:progressBlock completedBlock:completedBlock forURL:url createCallback:^{
        //创建下载的回调,我们开始来看看创建完下载的回调之后里面都写了什么事情
        //配置下载超时的时间
        NSTimeInterval timeoutInterval = wself.downloadTimeout;
        if (timeoutInterval == 0.0) {
            timeoutInterval = 15.0;
        }

        // In order to prevent from potential duplicate caching (NSURLCache + SDImageCache) we disable the cache for image requests if told otherwise
        /**
         创建请求对象,并根据options参数设置其属性
         为了避免潜在的重复缓存(NSURLCache + SDImageCache)，
         如果没有明确告知需要缓存，
         则禁用图片请求的缓存操作, 这样就只有SDImageCache进行了缓存
         这里的options 是SDWebImageDownloaderOptions
         */
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:(options & SDWebImageDownloaderUseNSURLCache ? NSURLRequestUseProtocolCachePolicy : NSURLRequestReloadIgnoringLocalCacheData) timeoutInterval:timeoutInterval];
        // 通过设置 NSMutableURLRequest.HTTPShouldHandleCookies = YES
        //的方式来处理存储在NSHTTPCookieStore的cookies
        request.HTTPShouldHandleCookies = (options & SDWebImageDownloaderHandleCookies);
        //返回在接到上一个请求得得响应之前,饰扣需要传输数据,YES传输,NO不传输
        request.HTTPShouldUsePipelining = YES;
        /**
         如果你自定义了wself.headersFilter,那就用你自己设置的
         wself.headersFilter来设置HTTP的header field
         它的定义是
         typedef NSDictionary *(^SDWebImageDownloaderHeadersFilterBlock)(NSURL *url, NSDictionary *headers);
         一个返回结果为NSDictionary类型的block
         如果你没有自己设置wself.headersFilter那么就用SDWebImage提供的HTTPHeaders
         HTTPHeaders在#import "SDWebImageDownloader.h",init方法里面初始化,下载webp图片需要的header不一样
         (WebP格式，[谷歌]开发的一种旨在加快图片加载速度的图片格式。图片压缩体积大约只有JPEG的2/3，并能节省大量的服务器带宽资源和数据空间)
         #ifdef SD_WEBP
         _HTTPHeaders = [@{@"Accept": @"image/webp,image/*;q=0.8"} mutableCopy];
         #else
         _HTTPHeaders = [@{@"Accept": @"image/*;q=0.8"} mutableCopy];
         #endif
         */
        if (wself.headersFilter) {
            request.allHTTPHeaderFields = wself.headersFilter(url, [wself.HTTPHeaders copy]);
        }
        else {
            request.allHTTPHeaderFields = wself.HTTPHeaders;
        }
        /**
         创建SDWebImageDownLoaderOperation操作对象(下载的操作就是在SDWebImageDownLoaderOperation类里面进行的)
         传入了进度回调,完成回调,取消回调
         @property (assign, nonatomic) Class operationClass;
         将Class作为属性存储,初始化具体Class,使用的时候调用具体class的方法
         */
        operation = [[wself.operationClass alloc] initWithRequest:request
                                                          options:options
                                                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                             //progress block回调的操作
                                                             SDWebImageDownloader *sself = wself;
                                                             if (!sself) return;
                                                             /**
                                                              URLCallbacks是一个字典,key是url,value是一个数组,
                                                              数组里面装的是字典,key是NSString代表着回调类型,value为block是对应的回调
                                                              确保提交的block是指定队列中特定时段唯一在执行的一个.
                                                              */
                                                             __block NSArray *callbacksForURL;
                                                             dispatch_sync(sself.barrierQueue, ^{
                                                                 callbacksForURL = [sself.URLCallbacks[url] copy];
                                                             });
                                                             for (NSDictionary *callbacks in callbacksForURL) {
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     //根据kProgressCallbackKey这个key取出进度的操作
                                                                     SDWebImageDownloaderProgressBlock callback = callbacks[kProgressCallbackKey];
                                                                     //返回已经接收的数据字节,以及未接收的数据(预计字节)
                                                                     if (callback) callback(receivedSize, expectedSize);
                                                                 });
                                                             }
                                                         }
                                                        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                            //completed block 回调的操作
                                                            SDWebImageDownloader *sself = wself;
                                                            if (!sself) return;
                                                            //依旧是根据url这个key取出一个里面装了字典的数组
                                                            __block NSArray *callbacksForURL;
                                                            dispatch_barrier_sync(sself.barrierQueue, ^{
                                                                callbacksForURL = [sself.URLCallbacks[url] copy];
                                                                //如果这个任务已经完成,就根据url这个key从URLCallbacks字典里面删除
                                                                if (finished) {
                                                                    [sself.URLCallbacks removeObjectForKey:url];
                                                                }
                                                            });
                                                            //根据kCompletedCallbackKey这个key取出SDWebImageDownloaderCompletedBlock(完成的block)
                                                            for (NSDictionary *callbacks in callbacksForURL) {
                                                                SDWebImageDownloaderCompletedBlock callback = callbacks[kCompletedCallbackKey];
                                                                //回调 图片 data error 是否完成的
                                                                if (callback) callback(image, data, error, finished);
                                                            }
                                                        }
                                                        cancelled:^{
                                                            //将url对应的所有回调移除
                                                            SDWebImageDownloader *sself = wself;
                                                            if (!sself) return;
                                                            dispatch_barrier_async(sself.barrierQueue, ^{
                                                                [sself.URLCallbacks removeObjectForKey:url];
                                                            });
                                                        }];
        //上面 是SDWebImageDownloaderOperation *operation的创建,从这里开始就都是对operation的配置
        // 设置是否需要解压
        operation.shouldDecompressImages = wself.shouldDecompressImages;
        
        /**
         用户认证 NSURLCredential
         当连接客户端与服务端进行数据传输的时候,web服务器
         收到客户端请求时可能需要先验证客户端是否是正常用户,再决定是否返回该接口的真实数据
         iOS7.0之前使用的网络框架是NSURLConnection,在 2013 的 WWDC 上，
         苹果推出了 NSURLConnection 的继任者：NSURLSession
         SDWebImage使用的是NSURLConnection,这两种网络框架的认证调用的方法也是不一样的,有兴趣的可以去google一下这里只看下NSURLConnection的认证(在这里写看着有些吃力,移步到这个代码框外面阅读)
         */
        
        /**
         *  NSURLCredential 身份认证
         
         认证过程：
         
         1.web服务器接收到来自客户端的请求
         
         2.web服务并不直接返回数据,而是要求客户端提供认证信息,也就是说挑战是服务端向客户端发起的
         
         2.1要求客户端提供用户名与密码挑战 NSInternetPassword
         
         2.2 要求客户端提供客户端证书 NSClientCertificate
         
         2.3要求客户端信任该服务器
         
         3.客户端回调执行,接收到需要提供认证信息,然后提供认证信息,并再次发送给web服务
         
         4.web服务验证认证信息
         
         4.1认证成功,将最终的数据结果发送给客户端
         
         4.2认证失败,错误此次请求,返回错误码401
         
         Web服务需要验证客户端网络请求
         
         NSURLConnectionDelegate 提供的接收挑战,SDWeImage使用的就是这个方案
         */
        if (wself.urlCredential) {
            operation.credential = wself.urlCredential;
        } else if (wself.username && wself.password) {
            operation.credential = [NSURLCredential credentialWithUser:wself.username password:wself.password persistence:NSURLCredentialPersistenceForSession];
        }
        //根据下载选项SDWebImageDownloaderHighPriority设置优先级
        if (options & SDWebImageDownloaderHighPriority) {
            operation.queuePriority = NSOperationQueuePriorityHigh;
        } else if (options & SDWebImageDownloaderLowPriority) {
            operation.queuePriority = NSOperationQueuePriorityLow;
        }

        //将下载操作加到下载队列中
        [wself.downloadQueue addOperation:operation];
        /**
         根据executionOrder设置操作的依赖关系
         executionOrder代表着下载操作执行的顺序,它是一个枚举
         SD添加下载任务是同步的，而且都是在self.barrierQueue这个并行队列中，
         同步添加任务。这样也保证了根据executionOrder设置依赖关是正确的。
         换句话说如果创建下载任务不是使用dispatch_barrier_sync完成的，而是使用异步方法 ，虽然依次添加创建下载操作A、B、C的任务，但实际创建顺序可能为A、C、B，这样当executionOrder的值是SDWebImageDownloaderLIFOExecutionOrder，设置的操作依赖关系就变成了A依赖C，C依赖B
         typedef NS_ENUM(NSInteger, SDWebImageDownloaderExecutionOrder) {
         // 默认值，所有的下载操作以队列类型执行,先被加入下载队列的操作先执行
         SDWebImageDownloaderFIFOExecutionOrder,
         // 所有的下载操作以栈类型执行,后进先出,后被加入下载队列的操作先执行
         SDWebImageDownloaderLIFOExecutionOrder
         };
         */
        if (wself.executionOrder == SDWebImageDownloaderLIFOExecutionOrder) {
            // Emulate LIFO execution order by systematically adding new operations as last operation's dependency
            [wself.lastAddedOperation addDependency:operation];
            wself.lastAddedOperation = operation;
        }
    }];

    return operation;
}

- (void)addProgressCallback:(SDWebImageDownloaderProgressBlock)progressBlock completedBlock:(SDWebImageDownloaderCompletedBlock)completedBlock forURL:(NSURL *)url createCallback:(SDWebImageNoParamsBlock)createCallback {
    // The URL will be used as the key to the callbacks dictionary so it cannot be nil. If it is nil immediately call the completed block with no image or data.
    //如果图片的url是空的就直接返回
    if (url == nil) {
        if (completedBlock != nil) {
            completedBlock(nil, nil, nil, NO);
        }
        return;
    }

    /**
     *  Dispatch Barrier解决多线程并发读写一个资源发生死锁
        sync说明了这是个同步函数,任务不会立即返回,会等到任务执行结束才返回。
     
     使用dispatch_barrier_sync此函数创建的任务会首先去查看队列中有没有别的任务要执行,如果有则会等待已有任务执行完毕再执行;同时在此方法后添加的任务必须等到此方法中任务执行后才能执行,利用这个方法可以控制执行顺序。
     
     Dispatch   Barrier确保提交的block是指定队列中特定时段唯一在执行的一个.在所有先于Dispatch Barrier的任务都完成的情况下这个block才开始执行.轮到这个block时barrier会执行这个block并且确保队列在此过程 不会执行其他任务.block完成后才恢复队列。
     
     这是用户自己创建的队列,DISPATCH_QUEUE_CONCURRENT代表的是它是一个并行队列,为什么选择并发队列而不是串行队列我们来想一下:
     
     串行队列可以保证任务按照添加的顺序一个个开始执行,并且上一个任务结束才开始下一个任务,这已经可以保证任务的执行顺序(或者说是任务结束的顺利)了,但是并行队列不一样,并发队列只能保证任务的开始,至于任务以什么样的顺序结束并不能保证但是并发队列使用Barrier却是可以保证的
     */
    // 以 dispatch_barrier_sync 操作来保证同一时间只有一个线程能对 URLCallbacks 进行操作
    dispatch_barrier_sync(self.barrierQueue, ^{
        /**
         *  URLCallbacks是一个可变字典,key是NSURL类型,value为NSMutableArray类型,value(数组里面)只包含一个元素,这个元素的类型是NSMutableDictionary类型,这个字典的key为NSString类型代表着回调类型,value为block,是对应的回调
         
         这些代码的目的都是为了给url绑定回调
         */
        BOOL first = NO;
        if (!self.URLCallbacks[url]) {
            self.URLCallbacks[url] = [NSMutableArray new];
            first = YES;
        }

        // Handle single download of simultaneous download request for the same URL
        // 处理同一 URL 的同步下载请求的单个下载
        NSMutableArray *callbacksForURL = self.URLCallbacks[url];
        NSMutableDictionary *callbacks = [NSMutableDictionary new];
        if (progressBlock) callbacks[kProgressCallbackKey] = [progressBlock copy];
        if (completedBlock) callbacks[kCompletedCallbackKey] = [completedBlock copy];
        [callbacksForURL addObject:callbacks];
        self.URLCallbacks[url] = callbacksForURL;

        /**
         *  如果url第一次绑定它的回调,也就是第一次使用这个url创建下载任务则执行一次创建回调
         
         在创建回调中 创建下载操作(下载操作并不是在这里创建的),dispatch_barrier_sync执行确保同一时间只有一个线程操作URLCallbacks属性,也就是确保了下面创建过程中在给operation传递回调的时候能取到正确的self.URLCallbacks[url]值,同事确保后面有相同的url再次创建的时候if (!self.URLCallbacks[url])分支不再进入,first==NO,也就不再继续调用创建回调,这样就确保了同一个url对应的图片不会重复下载
         
         以上这部分代码总结起来只做了一件事情:在barrierQueue队列中创建下载任务
         */
        if (first) {
            createCallback();
        }
    });
}

- (void)setSuspended:(BOOL)suspended {
    [self.downloadQueue setSuspended:suspended];
}

@end
