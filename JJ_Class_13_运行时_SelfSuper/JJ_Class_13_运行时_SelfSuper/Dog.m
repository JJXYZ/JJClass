//
//  Dog.m
//  JJ_Class_13_运行时_SelfSuper
//
//  Created by Jay on 2018/7/31.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "Dog.h"
#import <objc/runtime.h>
@implementation Dog

- (void)speak {
    NSLog(@"my name is %@", self.name);
}

- (void)speak1
{
    unsigned int numberOfIvars = 0;
    Ivar *ivars = class_copyIvarList([self class], &numberOfIvars);
    for(const Ivar *p = ivars; p < ivars+numberOfIvars; p++) {
        Ivar const ivar = *p;
        ptrdiff_t offset = ivar_getOffset(ivar);
        const char *name = ivar_getName(ivar);
        NSLog(@"Sark ivar name = %s, offset = %td", name, offset);
    }
    NSLog(@"my name is %p", &_name);
    NSLog(@"my name is %@", *(&_name));
}

@end
