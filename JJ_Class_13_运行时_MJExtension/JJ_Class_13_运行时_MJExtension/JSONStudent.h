//
//  JSONStudent.h
//  JJ_Class_13_运行时_MJExtension
//
//  Created by Jay on 2016/9/13.
//  Copyright © 2016年 Jay. All rights reserved.
//

#import "JSONModel.h"

@interface JSONStudent : JSONModel

@property (nonatomic, strong, nullable) NSString *name;

@property (nonatomic, strong, nullable) NSString *height;

+ (nullable JSONStudent *)parserEntityWithDictionary:(nullable NSDictionary *)dictionary;

@end
