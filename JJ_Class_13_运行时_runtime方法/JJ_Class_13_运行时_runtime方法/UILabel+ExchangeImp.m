//
//  UILabel+ExchangeImp.m
//  JJ_Class_13_运行时_runtime方法
//
//  Created by Jay on 2016/9/26.
//  Copyright © 2016年 Jay. All rights reserved.
//

#import "UILabel+ExchangeImp.h"
#import <objc/runtime.h>

@implementation UILabel (ExchangeImp)
#if 0
+ (void)load {
    NSLog(@"load UILabel");
    SEL method1Sel1 = NSSelectorFromString(@"setFont:");
    SEL method1Sel2 = NSSelectorFromString(@"ex_setFont:");
    
    Method method1 = class_getInstanceMethod([self class], method1Sel1);
    Method method2 = class_getInstanceMethod([self class], method1Sel2);
    
    
    BOOL didAddMethod =
    class_addMethod([self class],
                    method1Sel1,
                    method_getImplementation(method2),
                    method_getTypeEncoding(method2));
    
    if (didAddMethod) {
        class_replaceMethod([self class],
                            method1Sel2,
                            method_getImplementation(method1),
                            method_getTypeEncoding(method1));
    } else {
        method_exchangeImplementations(method1, method2);
    }
}

- (void)ex_setFont:(UIFont *)font {
    NSLog(@"ex_setFont");
    
    [self ex_setFont:[UIFont fontWithName:@"Bodoni 72 Smallcaps" size:16]];
    
}
#endif

@end
