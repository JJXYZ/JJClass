//
//  Beverage.m
//  JJ_Class_20_设计模式_装饰者
//
//  Created by Jay on 2016/9/20.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "Beverage.h"

@interface Beverage ()



@end

@implementation Beverage

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.desc = @"Unknown Beverage";
    }
    return self;
}

#pragma mark - Public Methods

- (float)cost {
    return 0;
}

- (NSString *)getDesccription {
    return self.desc;
}

@end
