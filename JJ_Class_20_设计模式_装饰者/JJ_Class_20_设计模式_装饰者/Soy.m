//
//  Soy.m
//  JJ_Class_20_设计模式_装饰者
//
//  Created by Jay on 2016/9/20.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "Soy.h"

@interface Soy ()

@property (nonatomic, strong) Beverage *beverage;

@end

@implementation Soy

- (instancetype)initWithBeverage:(Beverage *)beverage
{
    self = [super init];
    if (self) {
        self.beverage = beverage;
    }
    return self;
}

- (float)cost {
    return 0.30 + [self.beverage cost];
}

- (NSString *)getDesccription {
    NSString *string = [NSString stringWithFormat:@"%@,%@", [self.beverage getDesccription], @"Soy"];
    return string;
}

@end
