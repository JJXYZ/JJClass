//
//  ViewController.m
//  JJ_Class_18_崩溃_断言
//
//  Created by Jay on 2016/9/19.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAssert(NO, @"js exception");
}


@end
