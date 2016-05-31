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
#import "VCVM.h"

@interface ViewController ()

@property (nonatomic, strong) VCVM *vcVM;

@property (nonatomic, strong) NSArray *flags;
@property (weak, nonatomic) IBOutlet UIButton *Button_RACCommond;

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcVM = [[VCVM alloc] init];

    [self setupSubjectRAC];
//    [self createSignal];
//    [self createRACSequence];
//    [self createRACCommand];
//    [self signalOfSignals];
//    [self createRACMulticastConnection];
}

#pragma mark - RACMulticastConnection

- (void)createRACMulticastConnection {
    // 发送请求，用一个信号内包装，不管有多少个订阅者，只想要发送一次请求
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // didSubscribeblock中的代码都统称为副作用。
        // 发送请求
        NSLog(@"发送请求");
        
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    //    // 订阅信号
    //    [signal subscribeNext:^(id x) {
    //
    //        NSLog(@"%@",x);
    //    }];
    //
    //
    //    [signal subscribeNext:^(id x) {
    //
    //        NSLog(@"%@",x);
    //    }];
    
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

- (void)setupSubjectRAC {
    // 2.订阅信号
    [self.vcVM.subject subscribeNext:^(id x) {
        // block:当有数据发出的时候就会调用
        // block:处理数据
        NSLog(@"接收 %@",x);
    }];
    
    [self.vcVM.subject subscribeNext:^(id x) {
        // block:当有数据发出的时候就会调用
        // block:处理数据
        NSLog(@"接收2 %@",x);
    }];
}

- (IBAction)clickRACSubject:(id)sender {
    [self.vcVM createRACSubject];
}

#pragma mark - RACSignal

- (IBAction)clickRACSignal:(id)sender {
    RACSignal *signal = [self.vcVM createSignal];
    // subscribeNext:
    // 1.创建订阅者
    // 2.把nextBlock保存到订阅者里面
    // 订阅信号
    // 只要订阅信号，就会返回一个取消订阅信号的类
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        
        // block:只要信号内部发送数据，就会调用这个block
        NSLog(@"收到 %@",x);
    }];
    
    // 取消订阅
    [disposable dispose];
}




@end
