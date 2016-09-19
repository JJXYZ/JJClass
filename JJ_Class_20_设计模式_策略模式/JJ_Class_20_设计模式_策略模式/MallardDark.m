//
//  MallardDark.m
//  JJ_Class_20_设计模式_策略模式
//
//  Created by Jay on 2016/9/19.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "MallardDark.h"
#import "FlyWithWings.h"

@implementation MallardDark


#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.flyBehavior = [[FlyWithWings alloc] init];
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

#pragma mark - Property



@end
