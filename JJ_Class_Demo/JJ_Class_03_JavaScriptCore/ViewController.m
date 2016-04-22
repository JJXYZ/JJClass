//
//  ViewController.m
//  JJ_Class_03_JavaScriptCore
//
//  Created by Jay on 16/4/22.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "NativeObject.h"
#import "MYButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self createJSContext];
//    [self factorial];
//    [self testMakeUIColor];
//    [self addButton];
//    [self testLog];
    [self createMYButton];
}

- (void)createMYButton {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MYButtonJS" ofType:@"js"];
    NSString *testScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:testScript];
    
    MYButton *button = [MYButton buttonWithType:UIButtonTypeSystem];
    
    context[@"button"] = button;
    
    [context evaluateScript:@"button.setOnClickHandler('helloJS')"];
    
//    [self.view addSubview:button];
}

- (void)testLog
{
    JSContext *context = [[JSContext alloc] init];
    context[@"nativeObject"] = [[NativeObject alloc] init];
    [context evaluateScript:@"nativeObject.log(\"Hello Javascript\")"];
}

- (void)addButton
{
    /**
     *  通过运行时让 UIButton 遵循 UIButtonExport 协议
     */
    class_addProtocol([UIButton class],@protocol(UIButtonExport));
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Hello Objective-C" forState:UIControlStateNormal];
    button.frame = CGRectMake(20,40,280,40);
    
    JSContext *context = [[JSContext alloc]init];
    context[@"button"] = button;
    [context evaluateScript:@"button.setTitleForState('Hello JavaScript', 0)"];
    
    [self.view addSubview:button];
}

/** JavaScript → Objective-C */
- (void) testMakeUIColor
{
    JSContext *context = [[JSContext alloc] init];
    
    context[@"creatUIColor"] = ^(NSDictionary *rgbColor){
        return [UIColor colorWithRed:([rgbColor[@"red"] floatValue] /255.0)
                               green:([rgbColor[@"green"]floatValue] /255.0)
                                blue:([rgbColor[@"blue"]floatValue] /255.0)
                               alpha:1];
    };
    JSValue *color = [context evaluateScript:@"creatUIColor({red: 150, green: 150, blue: 200})"];
    NSLog(@"color:%@",[color toObject]);
}

/** Objective-C → JavaScript */
- (void)factorial
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"js"];
    NSString *testScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    /**
     JSContext：An instance of JSContext represents a JavaScript execution environment.（一个 Context 就是一个 JavaScript 代码执行的环境，也叫作用域。）
     */
    JSContext *context = [[JSContext alloc]init];
    [context evaluateScript:testScript];
    
    /**
     *  JSValue：Conversion between Objective-C and JavaScript types.（JS是弱类型的，ObjectiveC是强类型的，JSValue被引入处理这种类型差异，在 Objective-C 对象和 JavaScript 对象之间起转换作用）
     */
    JSValue *function = context[@"factorial"];
    JSValue *result = [function callWithArguments:@[@10]];
    NSLog(@"factorial(10) = %d", [result toInt32]);
}

- (void)createJSContext {
    JSContext *context = [[JSContext alloc] init];
    JSValue *result = [context evaluateScript:@"2 + 2"];
    NSLog(@"2 + 2 = %d", [result toInt32]);
}

@end
