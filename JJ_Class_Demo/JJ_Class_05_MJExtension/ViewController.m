//
//  ViewController.m
//  JJ_Class_05_MJExtension
//
//  Created by Jay on 15/11/25.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "ViewController.h"
#import "ViewController+MJKeyValues.h"
#import "MJExtension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self loadProperty];
    
    NSDictionary *dic = [[[UIView alloc] init] mj_keyValues];
    NSLog(@"self = %@", dic);
}

@end
