//
//  ModelDuck.m
//  JJ_Class_20_设计模式_策略模式
//
//  Created by Jay on 2016/9/19.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "ModelDuck.h"
#import "FlyNoWay.h"
#import "Quack.h"

@implementation ModelDuck

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.flyBehavior = [[FlyNoWay alloc] init];
        self.quackBehavior = [[Quack alloc] init];
    }
    return self;
}

#pragma mark - Public Methods

- (void)display {
    NSLog(@"MallardDark display");
}

- (void)performQuack {
    [self.quackBehavior quack];
}

@end
