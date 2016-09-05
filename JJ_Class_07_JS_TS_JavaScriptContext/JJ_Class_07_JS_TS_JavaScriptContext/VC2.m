//
//  VC2.m
//  JJ_Class_07_JS_TS_JavaScriptContext
//
//  Created by Jay on 16/8/31.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "VC2.h"
#import "JSListener.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface VC2 () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) JSListener *jsListener;

@property (nonatomic, strong) JSContext *jContext;

@end

@implementation VC2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.jsListener = [[JSListener alloc] init];
    
    NSURL* htmlURL = [[NSBundle mainBundle] URLForResource: @"ShareWebView" withExtension: @"htm"];
    
    [_webView loadRequest: [NSURLRequest requestWithURL: htmlURL]];
    _webView.delegate = self;
}

- (void)dealloc {
    NSLog(@"VC2 dealloc");
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStartLoadWithRequest");

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    
    NSString *webTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"webTitle = %@", webTitle);
    
    self.jContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jContext[@"webviewClickListener"] = self.jsListener;
    
}



@end
