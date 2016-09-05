//
//  ViewController.h
//  JJ_Class_07_JS_JavaScriptCore
//
//  Created by Jay on 16/8/31.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>

@protocol UIButtonExport <JSExport>

- (void)setTitle:(NSString *)title forState:(UIControlState)state;

@end

@interface ViewController : UIViewController


@end

