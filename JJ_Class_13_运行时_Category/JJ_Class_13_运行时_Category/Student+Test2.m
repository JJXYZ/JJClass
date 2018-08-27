//
//  Student+Test2.m
//  JJ_Class_13_运行时_Category
//
//  Created by Jay on 2018/8/7.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "Student+Test2.h"

@implementation Student (Test2)

#pragma mark - Super Methods

+ (void)load {
    NSLog(@"Student(Test2) + load");
}

//+ (void)initialize {
//    NSLog(@"Student(Test2) + initialize");
//}


@end
