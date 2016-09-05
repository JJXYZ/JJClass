//
//  VC1.m
//  JJ_Class_07_JS_TS_JavaScriptContext
//
//  Created by Jay on 16/8/31.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "VC1.h"
#import "JSListener.h"
#import "UIWebView+TS_JavaScriptContext.h"

@interface VC1 () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) JSListener *jsListener;

@end

@implementation VC1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.jsListener = [[JSListener alloc] init];
    
    NSURL* htmlURL = [[NSBundle mainBundle] URLForResource: @"ShareWebView" withExtension: @"htm"];
    
    [_webView loadRequest: [NSURLRequest requestWithURL: htmlURL]];
    _webView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //    JSContext *ctx = self.WebView.ts_javaScriptContext;
    //    ctx[@"ios"] = nil;
    
    self.jsListener = nil;
    
}

- (void)dealloc {
    NSLog(@"VC1 dealloc");
}


#pragma mark - TSWebViewDelegate

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx
{
    NSLog(@"ctx.globalObject.toString = %@", ctx.globalObject.toString);
    
    ctx[@"sayHello"] = ^{
        dispatch_async( dispatch_get_main_queue(), ^{
            NSLog(@"sayHello");
        });
    };
    
    ctx[@"webviewClickListener"] = self.jsListener;
//    ctx[@"ios"] = self;
}


@end
