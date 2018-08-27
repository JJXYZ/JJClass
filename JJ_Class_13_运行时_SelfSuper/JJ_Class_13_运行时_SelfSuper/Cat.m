//
//  Cat.m
//  JJ_Class_13_运行时_SelfSuper
//
//  Created by Jay on 2018/7/31.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "Cat.h"
#import "Dog.h"

@implementation Cat

- (instancetype)init1 {
    self = [super init];
    if (self) {
        id cls = [Dog class];
        void *obj = &cls;
        [(__bridge id)obj speak];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"Cat instance = %@", self);
        void *self2 = (__bridge void *)self;
        NSLog(@"Cat instance pointer = %p", &self2);
        id cls = [Dog class];
        NSLog(@"Dog Class = %p", cls);
        void *dogClassPointer = &cls;
        NSLog(@"Dog Class pointer = %@", dogClassPointer);
        [(__bridge id)dogClassPointer speak1];
    }
    return self;
}

@end
