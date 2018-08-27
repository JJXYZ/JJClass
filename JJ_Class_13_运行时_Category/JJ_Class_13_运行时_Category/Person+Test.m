//
//  Person+Test.m
//  JJ_Class_13_运行时_Category
//
//  Created by Jay on 2018/7/26.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "Person+Test.h"

@implementation Person (Test)

#pragma mark - Super Methods

+ (void)load {
    NSLog(@"Person (Test) + load");
}

//+ (void)initialize {
//    NSLog(@"Person (Test) + initialize");
//}

#pragma mark - Public Methods

+ (void)test2 {
    NSLog(@"Person test2");
}

- (void)test {
    NSLog(@"Person (Test) + test");
}

+ (void)test {
    NSLog(@"Person (Test) + test");
}

@end
