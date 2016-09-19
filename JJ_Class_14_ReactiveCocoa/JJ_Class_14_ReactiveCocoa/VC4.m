//
//  VC4.m
//  JJ_Class_14_ReactiveCocoa
//
//  Created by Jay on 2016/9/19.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "VC4.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface VC4 ()

@end

@implementation VC4

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createRACReplaySubject];
}


#pragma mark - RACMulticastConnection

- (void)createRACSignal {
    // 发送请求，用一个信号内包装，不管有多少个订阅者，只想要发送一次请求
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // didSubscribeblock中的代码都统称为副作用。
        // 执行多次
        NSLog(@"发送请求");
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    // 订阅信号
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];


    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

- (void)createRACMulticastConnection_1 {
    // 发送请求，用一个信号内包装，不管有多少个订阅者，只想要发送一次请求
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // didSubscribeblock中的代码都统称为副作用。
        // 执行一次
        NSLog(@"发送请求");
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    // 1.创建连接类
    RACMulticastConnection *connection = [signal publish];
    
    // 2.订阅信号
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"1 : %@",x);
    }];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"2 : %@",x);
    }];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"3 : %@",x);
    }];
    
    // 3.连接：才会把源信号变成热信号
    [connection connect];
}

#pragma mark - RACCommand

- (void)createRACCommand {
    // 使用注意点：RACCommand中的block不能返回一个nil的信号
    // 创建命令类
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        // block什么时候调用:当执行这个命令类的时候就会调用
        NSLog(@"执行命令 %@",input);
        // block有什么作用:描述下如何处理事件，网络请求
        
        // 返回数据 1
        
        // 为什么RACCommand必须返回信号，处理事件的时候，肯定会有数据产生，产生的数据就通过返回的信号发出。
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            // block作用：发送处理事件的信号
            // block调用：当信号被订阅的时候才会调用
            [subscriber sendNext:@"信号发出的内容"];
            
            return nil;
        }];
    }];
    //    _command = command;
    // executionSignals:信号源，包含事件处理的所有信号。
    // executionSignals: signalOfSignals,什么是信号中的信号，就是信号发出的数据也是信号类
    
    // 如果想要接收信号源的信号内容，必须保证命令类不会被销毁
    [command.executionSignals subscribeNext:^(id x) {
        // x -> 信号
        [x subscribeNext:^(id x) {
            
            NSLog(@"%@",x);
        }];
    }];
    
    // 2.执行命令,调用signalBlock
    [command execute:@1];
    
    
}

#pragma mark - RACSubject signalOfSignals
- (void)createRACSubject_signalOfSignals
{
    // 创建一个信号中的信号
    RACSubject *signalOfSignals = [RACSubject subject];
    
    // 信号
    RACSubject *signal = [RACSubject subject];
    
    // 先订阅
    [signalOfSignals subscribeNext:^(id x) {
        // x -> 信号
        NSLog(@"%@",x);
        
        [x subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    
    // 在发送
    [signalOfSignals sendNext:signal];
    [signal sendNext:@1];
    
}

#pragma mark - RACSequence
- (void)createRACSequence_array {
    // 创建集合
    // 使用场景：遍历数组或者字典
    NSArray *arr = @[@1,@2,@3];
    
    // 1.把数组转换成RAC中集合类RACSequence
    // 2.把RACSequence转换成信号
    // 3.订阅信号，订阅的信号是集合，就会遍历集合，把集合的数据全部发送出来
    [arr.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
}

- (void)createRACSequence_dic {
    NSDictionary *dict = @{@"key1":@1,@"key2":@2};
    
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *tuple) {
        NSLog(@"%@",tuple);
        NSString *key = tuple[0];
        NSString *value = tuple[1];
        NSLog(@"%@ %@", key, value);
    }];
}

- (void)createRACSequence_dic_tuple {
    NSDictionary *dict = @{@"key1":@1,@"key2":@2};
    
    // RACTupleUnpack宏：专门用来解析元组
    // RACTupleUnpack 等会右边：需要解析的元组 宏的参数，填解析的什么样数据
    // 元组里面有几个值，宏的参数就必须填几个
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *tuple) {
        NSLog(@"%@",tuple);
        RACTupleUnpack(NSString *key,NSString *value) = tuple;
        NSLog(@"%@ %@", key, value);
    }];
}

#pragma mark - RACReplaySubject

- (void)createRACReplaySubject {
    // 1.创建信号
    RACReplaySubject *subject = [RACReplaySubject subject];
//    RACSubject *subject = [RACSubject subject];
    
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        NSLog(@"ReplaySubject:第一个订阅者%@",x);
    }];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"ReplaySubject:第二个订阅者%@",x);
    }];
    
    // 3.发送信号
    [subject sendNext:@1];
    [subject sendNext:@2];
}


@end
