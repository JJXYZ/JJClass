//
//  SUTRuntimeMethodHelper.m
//  JJ_Class_Demo
//
//  Created by Jay on 15/11/26.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "SUTRuntimeMethodHelper.h"

@implementation SUTRuntimeMethodHelper

- (void)method2 {
    NSLog(@"%@, %p", self, _cmd);
}

@end
