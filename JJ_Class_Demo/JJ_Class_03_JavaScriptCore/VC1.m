//
//  VC1.m
//  JJ_Class_Demo
//
//  Created by Jay on 16/4/25.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "VC1.h"
#import <objc/runtime.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "MYButton.h"
#import "JSListener.h"

@interface VC1 ()

@property (nonatomic, strong) MYButton *button;
@property (nonatomic, strong) JSListener *jsListener;

@end

@implementation VC1

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self createMYButton];
    [self createJSListener];
}

- (void)dealloc {
    NSLog(@"VC1 dealloc");
}

#pragma mark - Private Method

- (void)createJSListener {
    
    JSContext *context = [[JSContext alloc] init];
    
    self.jsListener = [[JSListener alloc] init];
    
    context[@"jsListener"] = self.jsListener;
    context[@"ios"] = self;
    
    
    [context evaluateScript:@"jsListener.setShareText('1')"];
    
}

- (void)createMYButton {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MYButtonJS" ofType:@"js"];
    NSString *testScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:testScript];
    
    self.button = [MYButton buttonWithType:UIButtonTypeSystem];
    
    context[@"button"] = self.button;
    
    [context evaluateScript:@"button.setOnClickHandler('helloJS')"];
    
//    [self.view addSubview:self.button];
}


@end
