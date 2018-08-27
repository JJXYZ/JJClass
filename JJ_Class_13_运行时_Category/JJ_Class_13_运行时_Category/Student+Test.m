//
//  Student+Test.m
//  JJ_Class_13_运行时_Category
//
//  Created by Jay on 2018/8/7.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "Student+Test.h"

@implementation Student (Test)

#pragma mark - Super Methods

+ (void)load {
    NSLog(@"Student(Test) + load");
}

//+ (void)initialize {
//    NSLog(@"Student(Test) + initialize");
//}


@end
