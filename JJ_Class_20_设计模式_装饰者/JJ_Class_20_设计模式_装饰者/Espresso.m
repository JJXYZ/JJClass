//
//  Espresso.m
//  JJ_Class_20_设计模式_装饰者
//
//  Created by Jay on 2016/9/20.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "Espresso.h"

@implementation Espresso


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.desc = @"Espresso";
    }
    return self;
}

- (float)cost {
    return 1.99;
}

@end
