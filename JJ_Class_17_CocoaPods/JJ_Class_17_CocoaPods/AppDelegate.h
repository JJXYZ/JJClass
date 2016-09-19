//
//  AppDelegate.h
//  JJ_Class_17_CocoaPods
//
//  Created by Jay on 2016/9/19.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

/**
 *
 
 唐巧的技术博客:用CocoaPods做iOS程序的依赖管理
 http://blog.devtang.com/blog/2014/05/25/use-cocoapod-to-manage-ios-lib-dependency/
 
 生成个人的pods
 1.王中周的个人博客:CocoaPods详解之----制作篇
 http://blog.csdn.net/wzzvictory/article/details/20067595
 2.玉令天下的博客:Publish Your Pods on CocoaPods with Trunk
 http://yulingtianxia.com/blog/2014/05/26/publish-your-pods-on-cocoapods-with-trunk/
 
 安装pods
 
 万花筒 邪灵噶 的博客:cocoapods安装与使用
 http://blog.csdn.net/folish_audi/article/details/37501403
 Code4App:CocoaPods安装和使用教程
 http://code4app.com/article/cocoapods-install-usage
 最新版 CocoaPods 的安装流程
 http://www.tuicool.com/articles/7VvuAr3
 
 注意:
 1.gem sources -a https://ruby.taobao.org/  被干掉了使用 http://rubygems.org/
 2.sudo gem install cocoapods 备注：苹果系统升级 OS X EL Capitan 后改为 $sudo gem install -n /usr/local/bin cocoapods
 
 
 Podfile语法参考(译)
 http://www.jianshu.com/p/8af475c4f717
 
 王中周的个人博客:CocoaPods详解之----进阶篇
 http://blog.csdn.net/wzzvictory/article/details/19178709
 
 
 Recording:从工程中删除Cocoapods
 http://blog.csdn.net/freedom2028/article/details/10244819
 
 */



#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

