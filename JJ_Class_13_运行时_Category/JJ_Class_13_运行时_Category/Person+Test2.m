//
//  Person+Test2.m
//  JJ_Class_13_运行时_Category
//
//  Created by Jay on 2018/8/7.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "Person+Test2.h"

@implementation Person (Test2)

#pragma mark - Super Methods

+ (void)load {
    NSLog(@"Person (Test2) + load");
}

//+ (void)initialize {
//    NSLog(@"Person (Test2) + initialize");
//}

#pragma mark - Public Methods

+ (void)test {
    NSLog(@"Person (Test2) + test");
}

@end
