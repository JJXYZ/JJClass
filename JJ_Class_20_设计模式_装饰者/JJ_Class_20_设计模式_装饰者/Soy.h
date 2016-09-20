//
//  Soy.h
//  JJ_Class_20_设计模式_装饰者
//
//  Created by Jay on 2016/9/20.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "CondimentDecorator.h"

@interface Soy : CondimentDecorator

- (instancetype)initWithBeverage:(Beverage *)beverage;

@end
