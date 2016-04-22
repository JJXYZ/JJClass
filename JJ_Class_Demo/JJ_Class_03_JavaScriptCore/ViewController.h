//
//  ViewController.h
//  JJ_Class_03_JavaScriptCore
//
//  Created by Jay on 16/4/22.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol UIButtonExport <JSExport>

- (void)setTitle:(NSString *)title forState:(UIControlState)state;

@end

@interface ViewController : UIViewController


@end

