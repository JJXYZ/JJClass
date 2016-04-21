//
//  ViewController.m
//  JJ_Class_07_ReactiveCocoa
//
//  Created by Jay on 15/11/26.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACSubjectVC.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *flags;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

//    [self createSignal];
//    [self createRACSubject];
//    [self createRACSequence];
    [self createRACCommand];
    
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
    
    //    [self signalOfSignals];
}

- (void)signalOfSignals
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
- (void)createRACSequence {
#if 0
    // 创建集合
    // 使用场景：遍历数组或者字典
    NSArray *arr = @[@1,@2,@3];
    
    // 1.把数组转换成RAC中集合类RACSequence
    // 2.把RACSequence转换成信号
    // 3.订阅信号，订阅的信号是集合，就会遍历集合，把集合的数据全部发送出来
    [arr.rac_sequence.signal subscribeNext:^(id x) {

        NSLog(@"%@",x);
    }];
#endif
    
#if 1
    NSDictionary *dict = @{@"key1":@1,@"key2":@2};
    
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
#if 0
        NSLog(@"%@",x);
        NSString *key = x[0];
        NSString *value = x[1];
        NSLog(@"%@ %@", key, value);
#endif
#if 1
        // RACTupleUnpack宏：专门用来解析元组
        // RACTupleUnpack 等会右边：需要解析的元组 宏的参数，填解析的什么样数据
        // 元组里面有几个值，宏的参数就必须填几个
        RACTupleUnpack(NSString *key,NSString *value) = x;
        NSLog(@"%@ %@", key, value);
#endif
        
        
    }];
#endif
    
#if 0
    // 字典转模型
    NSString *path = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    // 解析plist文件
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:path];
    [dictArr.rac_sequence.signal subscribeNext:^(id x) {
        
        
    }];
#endif
}

#pragma mark - RACReplaySubject

- (IBAction)clickRACReplaySubject:(id)sender {
    // 1.创建信号
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者%@",x);
    }];
    
    [subject subscribeNext:^(id x) {
        
        NSLog(@"第二个订阅者%@",x);
    }];
    
    // 3.发送信号
    [subject sendNext:@1];
    
    [subject sendNext:@2];
}

#pragma mark - RACSubject

- (void)createRACSubject {
    // RACSubject:信号提供者
    
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        // block:当有数据发出的时候就会调用
        // block:处理数据
        NSLog(@"%@",x);
    }];
    
    // 3.发送信号
    [subject sendNext:@1];
    
    // 开发中，使用这个RACSubject代替代理
}

- (IBAction)clickRACSubject:(id)sender {
    RACSubjectVC *vc = [[RACSubjectVC alloc] init];
    [vc.subject subscribeNext:^(id x) {
        NSLog(@"通知了ViewController");
    }];
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - RACSiganl

- (void)createSignal {
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
    
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // block调用时刻:当信号被订阅的时候就会调用
        // block作用:描述当前信号哪些数据需要发送
        //       _subscriber = subscriber;
        // 发送数据
        NSLog(@"调用了didSubscribe");
        // 通常：传递数据出去
        [subscriber sendNext:@1];
        // 调用订阅者的nextBlock
        
        // 如果信号，想要被取消，就必须返回一个RACDisposable
        return [RACDisposable disposableWithBlock:^{
            
            // 信号什么时候被取消：1.自动取消，当一个信号的订阅者被销毁的时候，就会自动取消订阅 2.主动取消
            // block调用时刻:一旦一个信号，被取消订阅的时候就会调用
            // block作用：当信号取消订阅，用于清空一些资源
            NSLog(@"取消订阅");
        }];
    }];
    
    // subscribeNext:
    // 1.创建订阅者
    // 2.把nextBlock保存到订阅者里面
    // 订阅信号
    // 只要订阅信号，就会返回一个取消订阅信号的类
    RACDisposable *disposable = [siganl subscribeNext:^(id x) {
        
        // block:只要信号内部发送数据，就会调用这个block
        NSLog(@"%@",x);
    }];
    
    // 取消订阅
    [disposable dispose];
    
    // RACSignal使用步骤:
    // 1.创建信号
    
    // 2.订阅信号
    
    // RACSignal底层实现:
    // 1.当一个信号被订阅，创建订阅者，并且把nextBlock保存到订阅者里面
    // 2.[RACDynamicSignal subscribe:RACSubscriber]
    // 3.调用RACDynamicSignal的didSubscribe
    // 4.[subscriber sendNext:@1];
    // 5.拿到订阅者的nextBlock调用
}
@end
