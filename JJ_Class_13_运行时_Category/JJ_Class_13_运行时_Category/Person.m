//
//  Person.m
//  JJ_Class_13_运行时_Category
//
//  Created by Jay on 2018/7/26.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "Person.h"

@implementation Person

#pragma mark - Super Methods

+ (void)load {
    NSLog(@"Person + load");
}

+ (void)initialize {
    NSLog(@"Person + initialize");
}

#pragma mark - Public Methods

- (void)run {
    NSLog(@"Person run");
}

+ (void)test {
    NSLog(@"Person + test");
}

@end
