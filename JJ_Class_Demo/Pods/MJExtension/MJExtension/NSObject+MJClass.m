//
//  NSObject+MJClass.m
//  MJExtensionExample
//
//  Created by MJ Lee on 15/8/11.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "NSObject+MJClass.h"
#import "NSObject+MJCoding.h"
#import "NSObject+MJKeyValue.h"
#import "MJFoundation.h"
#import <objc/runtime.h>
#import "MJDictionaryCache.h"

static const char MJAllowedPropertyNamesKey = '\0';
static const char MJIgnoredPropertyNamesKey = '\0';
static const char MJAllowedCodingPropertyNamesKey = '\0';
static const char MJIgnoredCodingPropertyNamesKey = '\0';

@implementation NSObject (MJClass)

+ (void)mj_enumerateClasses:(MJClassesEnumeration)enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
        
        if ([MJFoundation isClassFromFoundation:c]) break;
    }
}

+ (void)mj_enumerateAllClasses:(MJClassesEnumeration)enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
    }
}

#pragma mark - 属性黑名单配置
/**
 *  Jay 这个数组中的属性名将会被忽略：不进行字典和模型的转换
 *
 *  @param ignoredPropertyNames          这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (void)mj_setupIgnoredPropertyNames:(MJIgnoredPropertyNames)ignoredPropertyNames
{
    [self mj_setupBlockReturnValue:ignoredPropertyNames key:&MJIgnoredPropertyNamesKey];
}
/**
 *  Jay 这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (NSMutableArray *)mj_totalIgnoredPropertyNames
{
    return [self mj_totalObjectsWithSelector:@selector(mj_ignoredPropertyNames) key:&MJIgnoredPropertyNamesKey];
}

#pragma mark - 归档属性黑名单配置
+ (void)mj_setupIgnoredCodingPropertyNames:(MJIgnoredCodingPropertyNames)ignoredCodingPropertyNames
{
    [self mj_setupBlockReturnValue:ignoredCodingPropertyNames key:&MJIgnoredCodingPropertyNamesKey];
}

+ (NSMutableArray *)mj_totalIgnoredCodingPropertyNames
{
    return [self mj_totalObjectsWithSelector:@selector(mj_ignoredCodingPropertyNames) key:&MJIgnoredCodingPropertyNamesKey];
}

#pragma mark - 属性白名单配置
/**
 *  Jay 这个数组中的属性名才会进行字典和模型的转换
 *
 *  @param allowedPropertyNames          这个数组中的属性名才会进行字典和模型的转换
 */
+ (void)mj_setupAllowedPropertyNames:(MJAllowedPropertyNames)allowedPropertyNames;
{
    [self mj_setupBlockReturnValue:allowedPropertyNames key:&MJAllowedPropertyNamesKey];
}

/**
 *  Jay 这个数组中的属性名才会进行字典和模型的转换
 */
+ (NSMutableArray *)mj_totalAllowedPropertyNames
{
    return [self mj_totalObjectsWithSelector:@selector(mj_allowedPropertyNames) key:&MJAllowedPropertyNamesKey];
}

#pragma mark - 归档属性白名单配置
+ (void)mj_setupAllowedCodingPropertyNames:(MJAllowedCodingPropertyNames)allowedCodingPropertyNames
{
    [self mj_setupBlockReturnValue:allowedCodingPropertyNames key:&MJAllowedCodingPropertyNamesKey];
}

+ (NSMutableArray *)mj_totalAllowedCodingPropertyNames
{
    return [self mj_totalObjectsWithSelector:@selector(mj_allowedCodingPropertyNames) key:&MJAllowedCodingPropertyNamesKey];
}
#pragma mark - block和方法处理:存储block的返回值
+ (void)mj_setupBlockReturnValue:(id (^)())block key:(const char *)key
{
    if (block) {
        objc_setAssociatedObject(self, key, block(), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    // 清空数据
    [[MJDictionaryCache dictWithDictId:key] removeAllObjects];
}

/**
 *  Jay 判断是否有SEL
 */
+ (NSMutableArray *)mj_totalObjectsWithSelector:(SEL)selector key:(const char *)key
{
    /** Jay 从缓存中获取到数组 */
    NSMutableArray *array = [MJDictionaryCache objectForKey:NSStringFromClass(self) forDictId:key];
    if (array) return array;
    
    // 创建、存储
    [MJDictionaryCache setObject:array = [NSMutableArray array] forKey:NSStringFromClass(self) forDictId:key];
    
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSArray *subArray = [self performSelector:selector];
#pragma clang diagnostic pop
        if (subArray) {
            [array addObjectsFromArray:subArray];
        }
    }
    
    [self mj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
        NSArray *subArray = objc_getAssociatedObject(c, key);
        [array addObjectsFromArray:subArray];
    }];
    return array;
}
@end
