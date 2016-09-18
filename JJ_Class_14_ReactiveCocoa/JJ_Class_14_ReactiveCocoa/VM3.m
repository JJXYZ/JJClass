//
//  MV3.m
//  JJ_Class_14_ReactiveCocoa
//
//  Created by Jay on 2016/9/18.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "VM3.h"


typedef void (^RWSignInResponse)(BOOL success);

@interface VM3 ()

/** TODO: */
@property (nonatomic, weak) id<VM3Protocol> vm3Imp;


@property (nonatomic, strong) NSNumber *isVisible;

@end

@implementation VM3

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

/** TODO: */
- (instancetype)initWithVM3Imp:(id<VM3Protocol>)vm3Imp {
    self = [super init];
    if (self) {
        _vm3Imp = vm3Imp;
        [self initialize];
    }
    return self;
}

#pragma mark - Private Methods

- (void)initialize {
    self.searchText = @"search text";
    self.title = @"Flickr Search";
    
    [self subscribeValidSearchSignal];
    [self signInSignal_skip];
}

- (void)signInComplete:(RWSignInResponse)completeBlock {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        completeBlock(YES);
    });
}

#pragma mark - RAC

/**
    上面的代码使用RACObserve宏来从ViewModel的searchText属性创建一个信号。map操作将文本转化为一个true或false值的流。
 
    最后，distinctUntilChanges确保信号只有在状态改变时才发出值。
 
    到目前为止，我们可以看到ReactiveCocoa被用于将绑定View绑定到ViewModel，确保了这两者是同步的。另进一步地，ViewModel内部的ReactiveCocoa代码用于观察自己的状态及执行其它操作。
 
    这就是MVVM模式的基本处理过程。ReactiveCocoa通常用于绑定View和ViewModel，但在程序的其它层也非常有用。
 */
- (RACSignal *)validSearchSignal {
    RACSignal *validSearchSignal = [[RACObserve(self, searchText) map:^id(NSString *text) {
        return @(text.length > 3);
    }] distinctUntilChanged];
    return validSearchSignal;
}

- (void)subscribeValidSearchSignal {
    RACSignal *validSearchSignal = [self validSearchSignal];
    [validSearchSignal subscribeNext:^(id x) {
        NSLog(@"search text is valid %@", x);
    }];
}

- (void)subscribeValidSearchSignal_RACTuple {
    RACSignal *validSearchSignal = [self validSearchSignal];
    [validSearchSignal subscribeNext:^(id x) {
        NSLog(@"search text is valid %@", x);
    }];
    
    // 提取第二个参数
    [[validSearchSignal map:^id(RACTuple *tuple) {
        return tuple.second;
    }] subscribeNext:^(id x) {
        NSLog(@"RACTuple:%@", x);
    }];
}



/**
    到目前为止，上述代码只提供了一个简单的实现：空信号会立即完成。delay操作会将其所接收到的next或complete事件延迟两秒执行。
 */
- (RACSignal *)executeSearchSignal {
    RACSignal *executeSearchSignal = [[[[RACSignal empty] logAll] delay:2.0] logAll];
    return executeSearchSignal;
}

- (RACSignal *)executeSearchSignal_1 {
    RACSignal *executeSearchSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"executeSearchSignal_1 subscriber");
        [subscriber sendNext:@(1)];
        [subscriber sendCompleted];
        return nil;
    }];
    return executeSearchSignal;
}

/** TODO: */
- (RACSignal *)executeSearchSignal_2 {
    RACSignal *executeSearchSignal = [[self.vm3Imp getSearchProtocol] searchSignal:self.searchText];
    return executeSearchSignal;
}


- (RACSignal *)signInSignal {
    RACSignal *signInSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self signInComplete:^(BOOL success) {
            if (self.isVisible.boolValue) {
                self.isVisible = @(NO);
            }
            else {
                self.isVisible = @(YES);
            }
            
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"RACDisposable");
        }];
    }];
    return signInSignal;
}

- (void)signInSignal_skip {
    // 1. 通过监听isVisible属性来创建信号。该信号发出的第一个next事件将包含这个属性的初始状态。
    // 因为我们只关心这个值的改变，所以在第一个事件上调用skip操作。
    RACSignal *visibleStateChanged = [RACObserve(self, isVisible) skip:5];
    
    // 2. 通过过滤visibleStateChanged信号来创建一个信号对，一个标识从可见到隐藏的转换，另一个标识从隐藏到可见的转换
    RACSignal *visibleSignal = [visibleStateChanged filter:^BOOL(NSNumber *value) {
        return [value boolValue];
    }];
    
    RACSignal *hiddenSignal = [visibleStateChanged filter:^BOOL(NSNumber *value) {
        return ![value boolValue];
    }];
    
    // 3. 这里是最神奇的地方。通过延迟visibleSignal信号1秒钟来创建fetchMetadata信号，在获取元数据之前暂停一会。
    // takeUntil操作确保如果cell在1秒的时间间隔内又一次隐藏时，来自visibleSignal的next事件被挂起且不获取元数据。
    RACSignal *fetchMetadata = [[visibleSignal delay:1.0f] takeUntil:hiddenSignal];
    
    [fetchMetadata subscribeNext:^(id x) {
        NSLog(@"signInSignal_skip : %@", x);
    }];
}


#pragma mark - Property

- (RACCommand *)executeSearchCommand {
    if (_executeSearchCommand) {
        return _executeSearchCommand;
    }
    _executeSearchCommand = [[RACCommand alloc] initWithEnabled:[self validSearchSignal] signalBlock:^RACSignal *(id input) {
        RACSignal *signal = [self signInSignal];
        return signal;
    }];
    return _executeSearchCommand;
}

@end
