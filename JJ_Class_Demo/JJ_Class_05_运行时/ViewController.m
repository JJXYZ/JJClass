//
//  ViewController.m
//  JJ_Class_05_运行时
//
//  Created by Jay on 15/11/25.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Class class = objc_getClass([@"NSString2" UTF8String]);
    NSLog(@"%@", NSStringFromClass(class));
}

@end
