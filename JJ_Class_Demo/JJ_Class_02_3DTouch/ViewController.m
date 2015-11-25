//
//  ViewController.m
//  JJ_Class_02_3DTouch
//
//  Created by Jay on 15/11/25.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIViewControllerPreviewingDelegate>
- (IBAction)clickBtn:(id)sender;

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createShortcutItem];
    
    // 注册Peek和Pop方法
    [self registerForPreviewingWithDelegate:self sourceView:self.view];
    
}

#pragma mark - Private Methods
/**
 *  创建icon的3DTcouch
 */
- (void)createShortcutItem {

    UIApplicationShortcutItem * item = [[UIApplicationShortcutItem alloc]initWithType:@"Two" localizedTitle:@"第二个标签" localizedSubtitle:@"看我哦" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypePlay] userInfo:nil];
    
    UIApplicationShortcutItem * item2 = [[UIApplicationShortcutItem alloc]initWithType:@"Third" localizedTitle:@"第三个标签" localizedSubtitle:@"看你妹" icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"Arrow"] userInfo:nil];

    [UIApplication sharedApplication].shortcutItems = @[item, item2];
}

#pragma mark - UIViewControllerPreviewingDelegate
/**
 *  创建应用内的3DTcouch
 */
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    UIViewController *vc = [[UIViewController alloc] init];
    
    return vc;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self clickBtn:nil];
    
}

#pragma mark - Event

- (IBAction)clickBtn:(id)sender {
}
@end
