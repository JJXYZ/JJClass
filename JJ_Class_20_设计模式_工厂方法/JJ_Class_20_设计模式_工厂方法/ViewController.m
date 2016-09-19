//
//  ViewController.m
//  JJ_Class_20_设计模式_工厂方法
//
//  Created by Jay on 2016/9/19.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "ViewController.h"
#import "BVClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BVClient *client = [[BVClient alloc] init];
    [client doSomething];
}


@end
