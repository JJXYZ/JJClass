//
//  ViewController.m
//  JJ_Class_07_JS_JavaScriptCore
//
//  Created by Jay on 16/8/31.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "ViewController.h"
#import "NativeObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self testResult];
//    [self factorial];
    
//    [self testMakeUIColor];
    
    [self testButton];
    
    
//    [self testNativeObject];
    
    
}

#pragma mark - Objective-C → JavaScript
/**
 *  一、Objective-C → JavaScript
 
 JSContext：An instance of JSContext represents a JavaScript execution environment.（一个 Context 就是一个 JavaScript 代码执行的环境，也叫作用域。）
 JSValue：Conversion between Objective-C and JavaScript types.（JS是弱类型的，ObjectiveC是强类型的，JSValue被引入处理这种类型差异，在 Objective-C 对象和 JavaScript 对象之间起转换作用）
 */

- (void)testResult {
    JSContext *context = [[JSContext alloc] init];
    JSValue *result = [context evaluateScript:@"2 + 2"];
    NSLog(@"2 + 2 = %d", [result toInt32]);
}

- (void)factorial
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"test"ofType:@"js"];
    NSString *testScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    JSContext *context = [[JSContext alloc]init];
    [context evaluateScript:testScript];
    
    JSValue *function = context[@"factorial"];
    JSValue *result = [function callWithArguments:@[@10]];
    NSLog(@"factorial(10) = %d", [result toInt32]);
}


#pragma mark - JavaScript → Objective-C

/**
 *  二、JavaScript → Objective-C
 
 Two ways to interact with Objective-C from JavaScript （可以通过两种方式在 JavaScript 中调用 Objective-C）
 ■ Blocks ：JS functions （对应 JS 函数）
 ■ JSExport protocol ：JS objects （对应 JS 对象）
 */


#pragma mark - Blocks
- (void)testMakeUIColor
{
    JSContext *context = [[JSContext alloc]init];
    
    context[@"creatUIColor"] = ^(NSDictionary *rgbColor){
        return [UIColor colorWithRed:([rgbColor[@"red"] floatValue] /255.0)
                               green:([rgbColor[@"green"]floatValue] /255.0)
                                blue:([rgbColor[@"blue"]floatValue] /255.0)
                               alpha:1];
    };
    JSValue *color = [context evaluateScript:@"makeUIColor({red: 150, green: 150, blue: 200})"];
    NSLog(@"color:%@",[color toObject]);
}

#pragma mark - JSExport protocol

- (void) testButton
{
    class_addProtocol([UIButton class],@protocol(UIButtonExport));
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Hello Objective-C"forState:UIControlStateNormal];
    button.frame = CGRectMake(20,40,280,40);
    
    JSContext *context = [[JSContext alloc] init];
    context[@"button"] = button;
    [context evaluateScript:@"button.setTitleForState('Hello JavaScript', 0)"];
    
    [self.view addSubview:button];
}  


- (void)testNativeObject
{
    JSContext *context = [[JSContext alloc]init];
    context[@"nativeObject"] = [[NativeObject alloc]init];
    [context evaluateScript:@"nativeObject.log(\"Hello Javascript\")"];
}

@end
