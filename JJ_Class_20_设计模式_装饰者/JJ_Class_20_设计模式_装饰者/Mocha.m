//
//  Mocha.m
//  JJ_Class_20_设计模式_装饰者
//
//  Created by Jay on 2016/9/20.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "Mocha.h"

@interface Mocha ()

@property (nonatomic, strong) Beverage *beverage;

@end

@implementation Mocha

- (instancetype)initWithBeverage:(Beverage *)beverage
{
    self = [super init];
    if (self) {
        self.beverage = beverage;
    }
    return self;
}

- (float)cost {
    return 0.20 + [self.beverage cost];
}

- (NSString *)getDesccription {
    NSString *string = [NSString stringWithFormat:@"%@,%@", [self.beverage getDesccription], @"Mocha"];
    return string;
}

@end
