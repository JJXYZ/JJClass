//
//  NSMutableDictionary+JJSafe.m
//  JJSafeDemo
//
//  Created by Jay on 15/11/10.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "NSMutableDictionary+JJSafe.h"

@implementation NSMutableDictionary (JJSafe)

+ (instancetype)safeWithDictionary:(NSDictionary *)dic {
    if (!dic) {
        return nil;
    }
    return [self dictionaryWithDictionary:dic];
}

- (void)safeSetObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
{
    if (!key) {
        return ;
    }
    
    if (!obj || [obj isKindOfClass:[NSNull class]]) {
        return ;
    }
    
    [self setObject:obj forKey:key];
}

- (void)safeSetObject:(id)aObj forKey:(id<NSCopying>)aKey
{
    if (aObj && ![aObj isKindOfClass:[NSNull class]] && aKey) {
        [self setObject:aObj forKey:aKey];
    } else {
        return;
    }
}

- (id)safeObjectForKey:(id<NSCopying>)aKey
{
    if (aKey != nil) {
        return [self objectForKey:aKey];
    } else {
        return nil;
    }
}

- (void)safeRemoveObjectForKey:(id<NSCopying>)aKey {
    if (aKey) {
        return [self removeObjectForKey:aKey];
    }
}


@end
