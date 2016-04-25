//
//  NSDictionary+JJSafe.h
//  JJSafeDemo
//
//  Created by Jay on 15/11/9.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JJSafe)

/** 安全存值 */
+ (id)safeDictionaryWithObject:(id)object forKey:(id <NSCopying>)key;

/** 安全返回id */
- (id)safeObjectForKey:(id)key;

/** 安全返回NSString */
- (NSString *)safeStringForKey:(id)key;

/** 安全返回NSArray */
- (NSArray *)safeArrayForKey:(id)key;

/** 安全返回NSDictionary */
- (NSDictionary *)safeDictionaryForKey:(id)key;

@end
