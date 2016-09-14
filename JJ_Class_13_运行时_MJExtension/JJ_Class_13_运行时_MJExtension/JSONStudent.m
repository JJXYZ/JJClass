//
//  JSONStudent.m
//  JJ_Class_13_运行时_MJExtension
//
//  Created by Jay on 2016/9/13.
//  Copyright © 2016年 Jay. All rights reserved.
//

#import "JSONStudent.h"

@implementation JSONStudent

+ (nullable JSONStudent *)parserEntityWithDictionary:(nullable NSDictionary *)dictionary
{
    if(!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSError *error = nil;
    JSONStudent *entity = [[self alloc] initWithDictionary:dictionary error:&error];
    return entity;
}


@end
