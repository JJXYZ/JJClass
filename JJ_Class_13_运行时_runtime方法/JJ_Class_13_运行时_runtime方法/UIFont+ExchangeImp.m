//
//  UIFont+ExchangeImp.m
//  JJ_Class_13_运行时_runtime方法
//
//  Created by Jay on 2016/9/26.
//  Copyright © 2016年 Jay. All rights reserved.
//

#import "UIFont+ExchangeImp.h"
#import <objc/runtime.h>

@implementation UIFont (ExchangeImp)

+ (void)load {
    NSLog(@"load UIFont");
    SEL method1Sel1 = NSSelectorFromString(@"systemFontOfSize:");
    SEL method1Sel2 = NSSelectorFromString(@"ex_systemFontOfSize:");
    
    Method method1 = class_getClassMethod([UIFont class], method1Sel1);
    Method method2 = class_getClassMethod([UIFont class], method1Sel2);
    method_exchangeImplementations(method1, method2);
    
//    BOOL didAddMethod =
//    class_addMethod([UIFont class],
//                    method1Sel1,
//                    method_getImplementation(method2),
//                    method_getTypeEncoding(method2));
//    
//    if (didAddMethod) {
//        class_replaceMethod([UIFont class],
//                            method1Sel2,
//                            method_getImplementation(method1),
//                            method_getTypeEncoding(method1));
//    } else {
//        method_exchangeImplementations(method1, method2);
//    }
}

+ (nullable UIFont *)ex_systemFontOfSize:(CGFloat)fontSize {
    NSLog(@"ex_systemFontOfSize");
//    UIFont *fount = [self ex_systemFontOfSize:fontSize];
    UIFont *fount = [self fontWithName:@"Bodoni 72 Smallcaps" size:fontSize];
    return fount;
}

+ (nullable UIFont *)ex_fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    UIFont *fount = [self ex_fontWithName:@"Bodoni 72 Smallcaps" size:16];
    return fount;
}

@end
