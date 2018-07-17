//
//  ViewController.m
//  JJ_Class_05_多线程_dispatch_sync
//
//  Created by Jay on 2018/7/17.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"1");
    
    dispatch_queue_t queue = dispatch_queue_create("", DISPATCH_QUEUE_CONCURRENT);
    
    // 打印当前队列的标签
    NSLog(@"%s", dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL));
    
    dispatch_async(queue, ^{
        sleep(1);
        NSLog(@"2 %@", [NSThread currentThread]);
        
        // 打印当前队列的标签
        NSLog(@"%s", dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL));
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"4 %@", [NSThread currentThread]);
        
        // 打印当前队列的标签
        NSLog(@"%s", dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL));
    });
    
    
    NSLog(@"3");
    // 打印当前队列的标签
    NSLog(@"%s", dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL));
    
    
}

@end









