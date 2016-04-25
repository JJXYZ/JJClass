//
//  NSDictionary+JJSafe.m
//  JJSafeDemo
//
//  Created by Jay on 15/11/9.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "NSDictionary+JJSafe.h"

@implementation NSDictionary (JJSafe)

+ (id)safeDictionaryWithObject:(id)object forKey:(id <NSCopying>)key
{
    if (object && key) {
        return [self dictionaryWithObject:object forKey:key];
    }
    else {
        return [self dictionary];
    }
}

- (id)safeObjectForKey:(id)key {
    if (!key) {
        return nil;
    }
    id obj = [self objectForKey:key];
    return obj;
}

- (NSString *)safeStringForKey:(id)key {
    
    if (!key) {
        return nil;
    }
    NSString *string = [self objectForKey:key];
    if (![string isKindOfClass:[NSString class]]) {
        string = nil;
    }
    return string;
}


- (NSArray *)safeArrayForKey:(id)key {
    if (!key) {
        return nil;
    }
    NSArray *array = [self objectForKey:key];
    if (![array isKindOfClass:[NSArray class]]) {
        array = nil;
    }
    return array;
}

- (NSDictionary *)safeDictionaryForKey:(id)key {
    if (!key) {
        return nil;
    }
    NSDictionary *dictionary = [self objectForKey:key];
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        dictionary = nil;
    }
    return dictionary;
}


@end
