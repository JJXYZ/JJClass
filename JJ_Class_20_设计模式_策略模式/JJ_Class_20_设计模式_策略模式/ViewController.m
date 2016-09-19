//
//  ViewController.m
//  JJ_Class_20_设计模式_策略模式
//
//  Created by Jay on 2016/9/19.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "ViewController.h"
#import "MallardDark.h"
#import "ModelDuck.h"
#import "FlyRocketPowered.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ModelDuck];
}


- (void)MallardDark {
    Dark *dark = [[MallardDark alloc] init];
    [dark performQuack];
    [dark performFly];
}

- (void)ModelDuck {
    Dark *dark = [[ModelDuck alloc] init];
    [dark performFly];
    
    FlyRocketPowered *flyBehavior = [[FlyRocketPowered alloc] init];
    [dark setFlyBehavior:flyBehavior];
    
    [dark performFly];
}


@end
