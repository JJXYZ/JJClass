//
//  ViewController.m
//  JJ_Class_20_设计模式_单例模式
//
//  Created by Jay on 2016/9/19.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "ViewController.h"
#import "BVNonARCSingleton.h"
#import "BVARCSingleton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BVNonARCSingleton sharedInstance].tempProperty = @"非ARC单例的实现";
    NSLog(@"%@", [BVNonARCSingleton sharedInstance].tempProperty);
    
    [BVARCSingleton sharedInstance].tempProperty = @"ARC单例的实现";
    NSLog(@"%@", [BVARCSingleton sharedInstance].tempProperty);
}


@end
