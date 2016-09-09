//
//  MyClass.h
//  JJ_Class_Demo
//
//  Created by Jay on 15/11/26.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyClass : NSObject <NSCopying, NSCoding>

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, copy) NSString *string;

- (void)method1;

- (void)method2;

+ (void)classMethod1;

@end
