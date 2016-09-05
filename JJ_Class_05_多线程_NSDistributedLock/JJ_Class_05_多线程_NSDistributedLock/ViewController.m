//
//  ViewController.m
//  JJ_Class_05_多线程_NSDistributedLock
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
    
    [self runDistributedLock];
}


- (void)runDistributedLock {
#if 0
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDistributedLock *lock = [[NSDistributedLock alloc] initWithPath:@"/Users/mac/Desktop/earning__"];
        [lock breakLock];
        [lock tryLock];
        sleep(10);
        [lock unlock];
        NSLog(@"appA: OK");
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        lock = [[NSDistributedLock alloc] initWithPath:@"/Users/mac/Desktop/earning__"];
        
        while (![lock tryLock]) {
            NSLog(@"appB: waiting");
            sleep(1);
        }
        [lock unlock];
        NSLog(@"appB: OK");
    });
#endif
}

@end
