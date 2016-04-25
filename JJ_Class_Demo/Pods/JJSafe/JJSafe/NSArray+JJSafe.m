//
//  NSArray+JJSafe.m
//  JJSafeDemo
//
//  Created by Jay on 15/11/8.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "NSArray+JJSafe.h"

@implementation NSArray (JJSafe)

+ (instancetype)safeArrayWithObject:(id)object
{
    if (object == nil) {
        return [self array];
    } else {
        return [self arrayWithObject:object];
    }
}


- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return nil;
    } else {
        return [self objectAtIndex:index];
    }
}


@end
