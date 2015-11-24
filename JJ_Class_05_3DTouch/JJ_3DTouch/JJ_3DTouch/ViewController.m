//
//  ViewController.m
//  JJ_3DTouch
//
//  Created by Jay on 15/11/23.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createShortcutItem];
    
}

#pragma mark - Private Methods

- (void)createShortcutItem {

    UIApplicationShortcutItem * item = [[UIApplicationShortcutItem alloc]initWithType:@"Two" localizedTitle:@"第二个标签" localizedSubtitle:@"看我哦" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypePlay] userInfo:nil];
    
    UIApplicationShortcutItem * item2 = [[UIApplicationShortcutItem alloc]initWithType:@"Third" localizedTitle:@"第三个标签" localizedSubtitle:@"看你妹" icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"Arrow"] userInfo:nil];

    [UIApplication sharedApplication].shortcutItems = @[item, item2];
}

@end
