//
//  BVAppDelegate.m
//  SingletonPattern
//
//  Created by BeyondVincent on 13-5-9.
//  Copyright (c) 2013年 BeyondVincent. All rights reserved.
//

#import "BVAppDelegate.h"

#import "BVNonARCSingleton.h"
#import "BVARCSingleton.h"

@implementation BVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [BVNonARCSingleton sharedInstance].tempProperty = @"非ARC单例的实现";
    NSLog(@"%@", [BVNonARCSingleton sharedInstance].tempProperty);
    
    [BVARCSingleton sharedInstance].tempProperty = @"ARC单例的实现";
    NSLog(@"%@", [BVARCSingleton sharedInstance].tempProperty);
    
    return YES;
}

@end
