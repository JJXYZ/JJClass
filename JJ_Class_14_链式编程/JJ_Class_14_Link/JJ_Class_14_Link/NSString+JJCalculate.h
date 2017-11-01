//
//  NSString+JJCalculate.h
//  JJ_Class_14_Link
//
//  Created by Jay on 2017/9/15.
//  Copyright © 2017年 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSComparisonResult(^JJComparisonResultBlock)(NSString *other);
typedef BOOL(^JJCompareBlock)(NSString *other);
typedef NSString *(^JJCalculateBlock)(NSString *other);

@interface NSString (JJCalculate)

- (JJComparisonResultBlock)comparisonResult;

- (JJCompareBlock)more;

- (JJCompareBlock)moreAndEqual;

- (JJCompareBlock)equal;

- (JJCompareBlock)less;

- (JJCompareBlock)lessAndEqual;

- (JJCompareBlock)notEqual;

- (JJCalculateBlock)calculateAdd;

- (JJCalculateBlock)calculateSub;

- (JJCalculateBlock)calculateMul;

- (JJCalculateBlock)calculateDiv;

@end
