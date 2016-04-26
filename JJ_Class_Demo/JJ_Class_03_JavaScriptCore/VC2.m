//
//  VC2.m
//  JJ_Class_Demo
//
//  Created by Jay on 16/4/26.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "VC2.h"
#import "JSListener.h"

@interface VC2 ()

@property (weak, nonatomic) IBOutlet UIWebView *WebView;

@property (nonatomic, strong) JSListener *jsListener;

@end

@implementation VC2

- (void)viewDidLoad {
    [super viewDidLoad];

    self.jsListener = [[JSListener alloc] init];
    
    NSURL* htmlURL = [[NSBundle mainBundle] URLForResource: @"ShareWebView"
                                             withExtension: @"htm"];
    
    [_WebView loadRequest: [NSURLRequest requestWithURL: htmlURL]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    JSContext *ctx = self.WebView.ts_javaScriptContext;
//    ctx[@"ios"] = nil;
}

- (void)dealloc {
    NSLog(@"VC2 dealloc");
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
    ctx[@"ios"] = self;
}




@end
