//
//  ViewController.m
//  JJ_Class_13_运行时_runtime方法
//
//  Created by Jay on 2016/9/9.
//  Copyright © 2016年 Jay. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self methodExchangeImpLabel];
}



- (void)methodExchangeImpLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 150, 100, 30)];
    label.text = @"你好333";
    label.font = [UIFont systemFontOfSize:20];
//    label.font = [UIFont fontWithName:@"Bodoni 72 Smallcaps" size:16];
    [self.view addSubview:label];
    
//    NSLog(@"%@", [UIFont familyNames]);
}

@end
