//
//  VC3.m
//  JJ_Class_Demo
//
//  Created by Jay on 16/4/26.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "VC3.h"
#import "JSListener.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface VC3 ()

@property (weak, nonatomic) IBOutlet UIWebView *WebView;

@property (nonatomic, strong) JSListener *jsListener;

@property (nonatomic, strong) JSContext *jContext;

@end

@implementation VC3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.jsListener = [[JSListener alloc] init];
    
    NSURL* htmlURL = [[NSBundle mainBundle] URLForResource: @"ShareWebView"
                                             withExtension: @"htm"];
    
    [_WebView loadRequest: [NSURLRequest requestWithURL: htmlURL]];
}

- (void)dealloc {
    NSLog(@"VC3 dealloc");
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStartLoadWithRequest");
    self.jContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jContext[@"webviewClickListener"] = self.jsListener;
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
