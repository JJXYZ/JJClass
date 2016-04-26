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

#import "VC1.h"
#import "VC2.h"
#import "VC3.h"

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
//    [self createJSContextToInt32];
//    [self createJSContextToArr];
//    [self createJSContextToSum];
}

#pragma mark - Event

- (IBAction)clickVC1 {
    VC1 *vc = [[VC1 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickVC2 {
    VC2 *vc = [[VC2 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickVC3 {
    VC3 *vc = [[VC3 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Private Method
- (void)createJSContextToException {
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *con, JSValue *exception) {
        NSLog(@"%@", exception);
        con.exception = exception;
    };
    
    [context evaluateScript:@"ider.zheng = 21"];
    
    //Output:
    //  ReferenceError: Can't find variable: ider
}

- (void)createJSContextToSum {
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"function add(a, b) { return a + b; }"];
    JSValue *add = context[@"add"];
    NSLog(@"Func:  %@", add);
    
    JSValue *sum = [add callWithArguments:@[@(7), @(21)]];
    NSLog(@"Sum:  %d",[sum toInt32]);
    //OutPut:
    //  Func:  function add(a, b) { return a + b; }
    //  Sum:  28
}

- (void)createJSContextToMethod {
    JSContext *context = [[JSContext alloc] init];
    context[@"log"] = ^() {
        NSLog(@"+++++++Begin Log+++++++");
        
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
        }
        
        JSValue *this = [JSContext currentThis];
        NSLog(@"this: %@",this);
        NSLog(@"-------End Log-------");
    };
    
    [context evaluateScript:@"log('ider', [7, 21], { hello:'world', js:100 });"];
    
    //Output:
    //  +++++++Begin Log+++++++
    //  ider
    //  7,21
    //  [object Object]
    //  this: [object GlobalObject]
    //  -------End Log-------
}

- (void)createJSContextToArr {
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"var arr = [21, 7 , 'iderzheng.com'];"];
    JSValue *jsArr = context[@"arr"]; // Get array from JSContext
    
    NSLog(@"JS Array: %@;    Length: %@", jsArr, jsArr[@"length"]);
    jsArr[1] = @"blog"; // Use JSValue as array
    jsArr[7] = @7;
    
    NSLog(@"JS Array: %@;    Length: %d", jsArr, [jsArr[@"length"] toInt32]);
    
    NSArray *nsArr = [jsArr toArray];
    NSLog(@"NSArray: %@", nsArr);
    
    //Output:
    //  JS Array: 21,7,iderzheng.com    Length: 3
    //  JS Array: 21,blog,iderzheng.com,,,,,7    Length: 8
    //  NSArray: (
    //   21,
    //   blog,
    //   "iderzheng.com",
    //   "<null>",
    //   "<null>",
    //   "<null>",
    //   "<null>",
    //   7
    //   )
}

- (void)createJSContextToInt32 {
    JSContext *context = [[JSContext alloc] init];
    JSValue *jsVal = [context evaluateScript:@"21+7"];
    int iVal = [jsVal toInt32];
    NSLog(@"JSValue: %@, int: %d", jsVal, iVal);
    
    //Output:
    //  JSValue: 28, int: 28
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
