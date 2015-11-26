//
//  MyObject.m
//  JJ_Class_Demo
//
//  Created by Jay on 15/11/26.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "MyObject.h"
#import <objc/runtime.h>

@interface MyObject()

@end

static NSMutableDictionary *map = nil;

@implementation MyObject

+ (void)load {
    
    map = [NSMutableDictionary dictionary];
    map[@"name1"]                = @"name";
    map[@"status1"]              = @"status";
    map[@"name2"]                = @"name";
    map[@"status2"]              = @"status";
    
}

- (void)setDataWithDic:(NSDictionary *)dic {
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        NSString *propertyKey = [map objectForKey:key];
        if (propertyKey) {
            objc_property_t property = class_getProperty([self class], [propertyKey UTF8String]);
            // TODO: 针对特殊数据类型做处理
            NSString *attributeString = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            [self setValue:obj forKey:propertyKey];
        }
    }];
}

@end
