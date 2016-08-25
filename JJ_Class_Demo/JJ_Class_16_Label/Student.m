//
//  Student.m
//  JJ_Class_Demo
//
//  Created by Jay on 16/8/17.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "Student.h"

@implementation Student

- (void)run {
    NSLog(@"Student run");
}

@end

@implementation Student (Category)

- (void)run {
    NSCAssert(NO, @"直接在父类中调用了 %s",__FUNCTION__);
    NSLog(@"Student Category run");
}

- (NSString *)run2 {
    [self run];
    return nil;
}


@end