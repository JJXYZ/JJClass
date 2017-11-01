//
//  JJPerson.m
//  JJ_Class_14_Link
//
//  Created by Jay on 2017/9/15.
//  Copyright © 2017年 JJ. All rights reserved.
//

#import "JJPerson.h"

@implementation JJPerson

#pragma mark - Public Methods

- (JJPersonSleepBlock)sleep {
    return ^(NSUInteger duration) {
        NSLog(@"sleep %lu", (unsigned long)duration);
    };
}

@end
