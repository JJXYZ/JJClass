//
//  ViewController.m
//  JJ_Class_12_崩溃
//
//  Created by Jay on 16/2/3.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AssertMethod];
}


- (void)AssertMethod {
//    assert(0);
    
    NSAssert(NO, @"js exception");
}

@end
