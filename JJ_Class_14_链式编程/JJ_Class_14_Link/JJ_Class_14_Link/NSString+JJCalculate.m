//
//  NSString+JJCalculate.m
//  JJ_Class_14_Link
//
//  Created by Jay on 2017/9/15.
//  Copyright © 2017年 JJ. All rights reserved.
//

#import "NSString+JJCalculate.h"



@implementation NSString (JJCalculate)

#pragma mark - Private Methods

- (NSDecimalNumber *)decimalWrapper {
    return [NSDecimalNumber decimalNumberWithString:self];
}

- (NSDecimal)decimalSturct {
    return self.decimalWrapper.decimalValue;
}

#pragma mark - Public Methods

- (JJComparisonResultBlock)comparisonResult {
    return ^NSComparisonResult(NSString *other) {
        return [self.decimalWrapper compare:other.decimalWrapper];
    };
}

- (JJCompareBlock)more {
    return ^BOOL(NSString *other) {
        NSComparisonResult result = [self.decimalWrapper compare:other.decimalWrapper];
        return (result == NSOrderedDescending);
    };
}

- (JJCompareBlock)moreAndEqual {
    return ^BOOL(NSString *other) {
        NSComparisonResult result = [self.decimalWrapper compare:other.decimalWrapper];
        return (result == NSOrderedDescending) || (result == NSOrderedSame);
    };
}

- (JJCompareBlock)equal {
    return ^BOOL(NSString *other) {
        NSComparisonResult result = [self.decimalWrapper compare:other.decimalWrapper];
        return (result == NSOrderedSame);
    };
}

- (JJCompareBlock)less {
    return ^BOOL(NSString *other) {
        NSComparisonResult result = [self.decimalWrapper compare:other.decimalWrapper];
        return (result == NSOrderedAscending);
    };
}

- (JJCompareBlock)lessAndEqual {
    return ^BOOL(NSString *other) {
        NSComparisonResult result = [self.decimalWrapper compare:other.decimalWrapper];
        return (result == NSOrderedAscending) || (result == NSOrderedSame);
    };
}

- (JJCompareBlock)notEqual {
    return ^BOOL(NSString *other) {
        NSComparisonResult result = [self.decimalWrapper compare:other.decimalWrapper];
        return (result != NSOrderedSame);
    };
}

- (JJCalculateBlock)calculateAdd {
    return ^NSString *(NSString *other) {
        return [self.decimalWrapper decimalNumberByAdding:other.decimalWrapper].stringValue;
    };
}

- (JJCalculateBlock)calculateSub {
    return ^NSString *(NSString *other) {
        return [self.decimalWrapper decimalNumberBySubtracting:other.decimalWrapper].stringValue;
    };
}

- (JJCalculateBlock)calculateMul {
    return ^NSString *(NSString *other) {
        return [self.decimalWrapper decimalNumberByMultiplyingBy:other.decimalWrapper].stringValue;
    };
}

- (JJCalculateBlock)calculateDiv {
    return ^NSString *(NSString *other) {
        return [self.decimalWrapper decimalNumberByDividingBy:other.decimalWrapper].stringValue;
    };
}



@end
