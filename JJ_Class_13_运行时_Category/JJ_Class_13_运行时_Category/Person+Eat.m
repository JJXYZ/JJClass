//
//  Person+Eat.m
//  JJ_Class_13_运行时_Category
//
//  Created by Jay on 2018/7/26.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "Person+Eat.h"

@implementation Person (Eat)

#pragma mark - Super Methods

+ (void)load {
    NSLog(@"Person (Eat) + load");
}

//+ (void)initialize {
//    NSLog(@"Person (Eat) + initialize");
//}

#pragma mark - Public Methods

- (void)eat {
    NSLog(@"Person eat");
}

+ (void)test {
    NSLog(@"Person (Eat) + test");
}

@end
