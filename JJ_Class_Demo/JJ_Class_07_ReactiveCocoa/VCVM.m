//
//  VCVM.m
//  JJ_Class_Demo
//
//  Created by Jay on 16/5/31.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "VCVM.h"
@interface VCVM ()

@end

@implementation VCVM

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        // RACSubject:信号提供者
        // 1.创建信号
        _subject = [RACSubject subject];
    }
    return self;
}


#pragma mark - RACSubject

- (void)createRACSubject {
    
    // 3.发送信号
    NSLog(@"发送 Subject");
    [self.subject sendNext:@"Subject"];
    
    // 开发中，使用这个RACSubject代替代理
}


#pragma mark - RACSignal

- (RACSignal *)createSignal {
    // 核心：信号类
    // 信号类作用：只要有数据改变，就会把数据包装成一个信号，传递出去。
    // 只要有数据改变，就会有信号发出。
    // 数据发出，并不是信号类发出。
    
    // 1.创建信号 createSignal:didSubscribe(block)
    // RACDisposable:取消订阅
    // RACSubscriber:发送数据
    
    // createSignal方法:
    // 1.创建RACDynamicSignal
    // 2.把didSubscribe保存到RACDynamicSignal
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // block调用时刻:当信号被订阅的时候就会调用
        // block作用:描述当前信号哪些数据需要发送
        //       _subscriber = subscriber;
        // 发送数据

        // 通常：传递数据出去
        NSLog(@"发送 RACSignal");
        [subscriber sendNext:@"RACSignal"];
        // 调用订阅者的nextBlock
        
        // 如果信号，想要被取消，就必须返回一个RACDisposable
        return [RACDisposable disposableWithBlock:^{
            
            // 信号什么时候被取消：1.自动取消，当一个信号的订阅者被销毁的时候，就会自动取消订阅 2.主动取消
            // block调用时刻:一旦一个信号，被取消订阅的时候就会调用
            // block作用：当信号取消订阅，用于清空一些资源
            NSLog(@"取消订阅");
        }];
    }];
    
    
    
    // RACSignal使用步骤:
    // 1.创建信号
    
    // 2.订阅信号
    
    // RACSignal底层实现:
    // 1.当一个信号被订阅，创建订阅者，并且把nextBlock保存到订阅者里面
    // 2.[RACDynamicSignal subscribe:RACSubscriber]
    // 3.调用RACDynamicSignal的didSubscribe
    // 4.[subscriber sendNext:@1];
    // 5.拿到订阅者的nextBlock调用
    
    return signal;
}


@end
