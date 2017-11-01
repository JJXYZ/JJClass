//
//  NSNumber+JJCalculate.m
//  JJ_Class_14_Link
//
//  Created by Jay on 2017/9/15.
//  Copyright © 2017年 JJ. All rights reserved.
//

#import "NSNumber+JJCalculate.h"

@implementation NSNumber (JJCalculate)

#pragma mark - Public Methods

- (NSDecimalNumber *)decimalWrapper {
    return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", self]];
}

- (NSDecimal)decimalSturct {
    return self.decimalValue;
}

@end
