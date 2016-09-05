//
//  ViewController.m
//  JJ_Class_05_多线程_NSConditionLock
//
//  Created by Jay on 16/8/31.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self runConditionLock];
}

- (void)runConditionLock {
    //主线程中
    NSConditionLock *theLock = [[NSConditionLock alloc] init];
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=0;i<=2;i++)
        {
            [theLock lock];
            NSLog(@"thread1:%d",i);
            sleep(2);
            [theLock unlockWithCondition:i];
        }
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [theLock lockWhenCondition:2];
        NSLog(@"thread2");
        [theLock unlock];
    });
}

@end
