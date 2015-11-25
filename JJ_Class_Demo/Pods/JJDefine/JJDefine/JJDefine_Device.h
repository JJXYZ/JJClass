//
//  JJDefine_Device.h
//  JJDefineDemo
//
//  Created by Jay on 15/11/18.
//  Copyright © 2015年 JJ. All rights reserved.
//

/**
 iPad Air {{0, 0}, {768, 1024}}
 iphone4s {{0, 0}, {320, 480}}     960*640     326ppi
 iphone5 {{0, 0}, {320, 568}}      1136*640    326ppi
 iphone6  {{0, 0}, {375, 667}}     1334*750    326ppi
 iphone6Plus {{0, 0}, {414, 736}}  1920*1080   401ppi
 Apple Watch 1.65英寸 320*640
 */


#ifndef JJDefine_Device_h
#define JJDefine_Device_h

/** 主屏幕的高度 */
#define M_SCREEN_H [[UIScreen mainScreen] bounds].size.height
/** 主屏幕的宽度 */
#define M_SCREEN_W  [[UIScreen mainScreen] bounds].size.width

/** 主屏幕的高度比例 */
#define M_SCREEN_H_SCALE (M_SCREEN_H/640)
/** 主屏幕的宽度比例 */
#define M_SCREEN_W_SCALE (M_SCREEN_W/320)


/** 屏幕的分辨率 当结果为1时，显示的是普通屏幕，结果为2时，显示的是Retian屏幕 */
#define M_SCREEN_SCALE [[UIScreen mainScreen] scale]

/** 除去信号区的屏幕的frame */
#define APP_FRAME  [[UIScreen mainScreen] applicationFrame]
/** 应用程序的屏幕高度 */
#define APP_FRAME_H   [[UIScreen mainScreen] applicationFrame].size.height
/** 应用程序的屏幕宽度 */
#define APP_FRAME_W    [[UIScreen mainScreen] applicationFrame].size.width


/** 系统控件的默认高度 */
#define D_STATUS_BAR_H   (20.f)
#define D_TOP_BAR_H      (44.f)
#define D_BOTTOM_BAR_H   (49.f)
#define D_CELL_H (44.f)

/** 中英状态下键盘的高度 */
#define ENG_KEY_BOARD_H  (216.f)
#define CHN_KEY_BOARD_H  (252.f)


#define IS_IOS6 (SYSTEM_VERSION >= 6.0 && SYSTEM_VERSION < 7)
#define IS_IOS7 (SYSTEM_VERSION >= 7.0 && SYSTEM_VERSION < 8.0)
#define IS_IOS8 (SYSTEM_VERSION >= 8.0 && SYSTEM_VERSION < 9.0)
#define IS_IOS9 (SYSTEM_VERSION >= 9.0 && SYSTEM_VERSION < 10.0)

/** 设备判断 */
#define IS_IPHONE [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define IS_PAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/** iPhone的型号 */
#define IS_IPHONE4 ([[UIScreen mainScreen] bounds].size.height == 480)
#define IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define IS_IPHONE6 ([[UIScreen mainScreen] bounds].size.height == 667)
#define IS_IPHONE6_PLUS ([[UIScreen mainScreen] bounds].size.height == 736)

/** 系统的版本号 */
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

/** APP版本号 */
#define APP_VERSION  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/** APP BUILD 版本号 */
#define APP_BUILD_VERSION  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

/** APP名字 */
#define APP_DISPLAY_NAME  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

/** 当前语言 */
#define LOCAL_LANGUAGE [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]

/** 当前国家 */
#define LOCAL_COUNTRY [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]

/** 当前使用Xcode iPhone OS SDK 的版本 */
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_0
NSLog(@"当前使用Xcode iPhone OS SDK 8.0 以后版本的处理");
#else
NSLog(@"当前使用Xcode iPhone OS SDK 8.0 之前版本的处理");
#endif


/** 判断设备室真机还是模拟器 */
#if TARGET_OS_IPHONE
#endif

#if TARGET_IPHONE_SIMULATOR
#endif

/** 判断系统为64位还是32位 */
#if __LP64__
NSLog(@"64");
#else
NSLog(@"32");
#endif


#endif /* JJDefine_Device_h */
