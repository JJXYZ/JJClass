//
//  AppDelegate.m
//  JJ_3DTouch
//
//  Created by Jay on 15/11/23.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler {
    
    
    NSLog(@"%@,%@,%@,%@", shortcutItem.type, shortcutItem.localizedTitle, shortcutItem.localizedSubtitle, shortcutItem.userInfo);
    
}


@end
