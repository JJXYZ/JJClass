//
//  Dark.m
//  JJ_Class_20_设计模式_策略模式
//
//  Created by Jay on 2016/9/19.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "Dark.h"
@interface Dark () {
    FlyBehavior *_flyBehavior;
}

@end

@implementation Dark
@synthesize flyBehavior = _flyBehavior;

#pragma mark - Public Methods

- (void)swim {
    NSLog(@"Dark swim");
}

- (void)display {
    NSLog(@"Dark display");
}

- (void)performQuack {
    [self.quackBehavior quack];
}

- (void)performFly {
    [self.flyBehavior fly];
}

#pragma mark - Property

- (FlyBehavior *)flyBehavior {
    if (_flyBehavior) {
        return _flyBehavior;
    }
    _flyBehavior = [[FlyBehavior alloc] init];
    return _flyBehavior;
}

- (void)setFlyBehavior:(FlyBehavior *)flyBehavior {
    _flyBehavior = flyBehavior;
}

- (QuackBehavior *)quackBehavior {
    if (_quackBehavior) {
        return _quackBehavior;
    }
    _quackBehavior = [[QuackBehavior alloc] init];
    return _quackBehavior;
}


@end
