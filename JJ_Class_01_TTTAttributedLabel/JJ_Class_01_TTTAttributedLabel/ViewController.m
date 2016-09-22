//
//  ViewController.m
//  JJ_Class_01_TTTAttributedLabel
//
//  Created by Jay on 2016/9/22.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "ViewController.h"
#import "TTTAttributedLabel.h"

static inline NSRegularExpression * NameRegularExpression() {
    static NSRegularExpression *_nameRegularExpression = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _nameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"^\\w+" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return _nameRegularExpression;
}

@interface ViewController () <TTTAttributedLabelDelegate>

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self TTTAttributedLabel];
}

#pragma mark - Private Methods

- (void)TTTAttributedLabel {
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(100, 120, 120, 60)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.numberOfLines = 0;
    //设置高亮颜色
    label.highlightedTextColor = [UIColor greenColor];
    //检测url
    label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    //对齐方式
    label.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    //行间距
    label.lineSpacing = 8;
    //设置阴影
    label.shadowColor = [UIColor grayColor];
    label.delegate = self; // Delegate
    //NO 不显示下划线
    label.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    NSString *text = @"Hello world";
    [label setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        //设置可点击文字的范围
        NSRange boldRange = [[mutableAttributedString string] rangeOfString:@"Hello" options:NSCaseInsensitiveSearch];
        //设定可点击文字的的大小
        UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:16];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        if (font) {
            //设置可点击文本的大小
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
            //设置可点击文本的颜色
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor purpleColor] CGColor] range:boldRange];
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
    
    //正则
    NSRegularExpression *regexp = NameRegularExpression();
    
    NSRange linkRange = [regexp rangeOfFirstMatchInString:text options:0 range:NSMakeRange(0, 3)];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.exiucai.com/"]];
    
    //设置链接的url
    [label addLinkToURL:url withRange:linkRange];
    
    [self.view addSubview:label];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"%@", url);
}




@end
