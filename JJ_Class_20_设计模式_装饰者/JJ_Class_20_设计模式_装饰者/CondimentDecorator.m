//
//  CondimentDecorator.m
//  JJ_Class_20_设计模式_装饰者
//
//  Created by Jay on 2016/9/20.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "CondimentDecorator.h"

@implementation CondimentDecorator

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.desc = @"CondimentDecorator";
    }
    return self;
}

#pragma mark - Public Methods

- (NSString *)getDesccription {
    return self.desc;
}
@end
