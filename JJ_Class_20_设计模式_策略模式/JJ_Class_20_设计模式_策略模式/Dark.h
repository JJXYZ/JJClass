//
//  Dark.h
//  JJ_Class_20_设计模式_策略模式
//
//  Created by Jay on 2016/9/19.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlyBehavior.h"
#import "QuackBehavior.h"

@interface Dark : NSObject

@property (nonatomic, strong) FlyBehavior *flyBehavior;

@property (nonatomic, strong) QuackBehavior *quackBehavior;


- (void)swim;

- (void)display;

- (void)performQuack;

- (void)performFly;

@end
