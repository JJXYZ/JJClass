//
//  ViewController.m
//  JJ_Class_13_运行时_Aspects
//
//  Created by Jay on 2016/9/9.
//  Copyright © 2016年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "Aspects/Aspects.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self aspect_Test];
    [self aspect];
}

#pragma mark - aspect方法
- (void)aspect {
    NSLog(@"aspect");
}

- (void)aspect_Test {
    
    [self aspect_hookSelector:@selector(aspect) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSLog(@"aspect_Test");
        
    }error:nil];
}

@end
