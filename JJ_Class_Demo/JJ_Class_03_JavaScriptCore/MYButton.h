//
//  MYButton.h
//  JJ_Class_Demo
//
//  Created by Jay on 16/4/22.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol MYButtonExport <JSExport>

- (void)setOnClickHandler:(JSValue *)handler;

@end

@interface MYButton : UIButton <MYButtonExport>

@property (nonatomic, strong) JSValue *jsValue;

@property (nonatomic, strong) NSString *string;

@property (nonatomic, strong) JSContext *context;

@property (nonatomic, strong) JSManagedValue *onClickHandler1;


- (void)setOnClickHandler:(JSValue *)handler;

@end
