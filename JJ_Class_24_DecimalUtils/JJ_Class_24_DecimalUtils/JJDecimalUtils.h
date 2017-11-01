//
//  JJDecimalUtils.h
//  JJ_Class_24_DecimalUtils
//
//  Created by Jay on 2017/8/14.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJDecimalUtils : NSObject

/**
 *  格式化 四舍不入
 *  1234.5678 2 -> 1234.56
 1234.50 2 -> 1234.5
 1234.00 2 -> 1234
 *
 *  @param doubleValue    价格
 *  @param scale 小数点后面保留几位
 */
+ (NSString *)roundDownWithDouble:(double)doubleValue scale:(short)scale;
+ (NSString *)roundDownWithString:(NSString *)stringValue scale:(short)scale;

+ (NSString *)roundDown2Double:(double)doubleValue;

+ (NSString *)roundDown2FormatDouble:(double)doubleValue;




+ (NSString *)roundDown4Double:(double)doubleValue;

+ (NSString *)roundDown4ZeroWithDouble:(double)doubleValue;

+ (NSString *)roundDown2ZeroWithDouble:(double)doubleValue;

@end
