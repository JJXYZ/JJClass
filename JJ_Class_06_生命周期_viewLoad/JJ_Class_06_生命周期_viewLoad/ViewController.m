//
//  ViewController.m
//  JJ_Class_06_生命周期_viewLoad
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
    NSLog(@" viewDidLoad ");
}

- (void)loadView {
    [super loadView];
    NSLog(@" loadView ");
}


@end
