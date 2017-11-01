//
//  JJDecimalUtils.m
//  JJ_Class_24_DecimalUtils
//
//  Created by Jay on 2017/8/14.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "JJDecimalUtils.h"

@implementation JJDecimalUtils

#pragma mark - Public Methods

+ (NSString *)roundDownWithString:(NSString *)stringValue scale:(short)scale {
    
    NSDecimalNumberHandler *decimalNumberHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO  raiseOnDivideByZero:NO];
    
    NSDecimalNumber *originDecimal = [NSDecimalNumber decimalNumberWithString:stringValue];
    NSDecimalNumber *roundDownDecimal = [originDecimal decimalNumberByRoundingAccordingToBehavior:decimalNumberHandler];
    
    NSString *string = [NSString stringWithFormat: @"%@" ,roundDownDecimal];
    
//    NSLog(@"(roundDownWithString:%@ scale:%d) -> %@", stringValue, scale, string);
    
    return string;
}


+ (NSString *)roundDownWithDouble:(double)doubleValue scale:(short)scale {
    
    NSDecimalNumberHandler *decimalNumberHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO  raiseOnDivideByZero:NO];
    
    NSString *stringValue = [NSString stringWithFormat:@"%f", doubleValue];
    NSDecimalNumber *originDecimal = [NSDecimalNumber decimalNumberWithString:stringValue];
    
    
    NSDecimalNumber *roundDownDecimal = [originDecimal decimalNumberByRoundingAccordingToBehavior:decimalNumberHandler];
    
    NSString *string = [NSString stringWithFormat: @"%@" ,roundDownDecimal];
    
//    NSLog(@"(roundDownWithDouble:%f scale:%d) -> %@", doubleValue, scale, string);
    
    return string;
}

+ (NSString *)roundDown2Double:(double)doubleValue {
    NSString *string = [NSString stringWithFormat:@"%.2f", [[self roundDownWithDouble:doubleValue scale:2] doubleValue]];
    
//    NSLog(@"(roundDown2Double:%f) -> %@", doubleValue, string);
    
    return string;
}

+ (NSString *)roundDown2FormatDouble:(double)doubleValue {
    NSString *string = [NSString stringWithFormat:@"%.2f", doubleValue];
    
//    NSLog(@"(roundDown2FormatDouble:%f) -> %@", doubleValue, string);
    
    return string;
}

+ (NSString *)formatter2ZeroStrWithDouble:(double)doubleValue {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingMode = NSNumberFormatterRoundFloor;
    [formatter setPositiveFormat:@"###,##0.00"];
    NSString *formattedString = [formatter stringFromNumber:[NSNumber numberWithDouble:doubleValue]];
    return formattedString;
}

+ (NSString *)formatter4ZeroStrWithDouble:(double)doubleValue {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###,##0.0000"];
    NSString *formattedString = [formatter stringFromNumber:[NSNumber numberWithDouble:doubleValue]];
    return formattedString;
}

+ (NSString *)roundDown2ZeroWithDouble:(double)doubleValue {
//    NSString *roundDownString = [self roundDown2Double:doubleValue];
    NSString *string =  [self formatter2ZeroStrWithDouble:doubleValue];
//     NSString *string = [NSString stringWithFormat:@"%.2f", roundDownString.doubleValue];
    
    NSLog(@"(roundDown2ZeroWithDouble:%f) -> %@", doubleValue, string);
    
    return string;
}

+ (NSString *)roundDown4Double:(double)doubleValue {
    return [self roundDownWithDouble:doubleValue scale:4];
}

+ (NSString *)roundDown4ZeroWithDouble:(double)doubleValue {
    NSString *roundDownString = [self roundDown4Double:doubleValue];
//    return [self formatter4ZeroStrWithDouble:roundDownString.doubleValue];
    NSString *string = [NSString stringWithFormat:@"%.4f", roundDownString.doubleValue];
    
    NSLog(@"(roundDown4ZeroWithDouble:%f) -> %@", doubleValue, string);
    
    return string;
}



@end
