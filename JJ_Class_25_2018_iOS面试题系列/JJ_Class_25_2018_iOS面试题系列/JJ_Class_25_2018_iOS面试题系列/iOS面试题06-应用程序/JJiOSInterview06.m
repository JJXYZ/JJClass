//
//  JJiOSInterview06.m
//  JJ_Class_25_2018_iOS面试题系列
//
//  Created by Jay on 2018/4/20.
//  Copyright © 2018年 com.xiaoniu88.XNOnline. All rights reserved.
//

#import "JJiOSInterview06.h"


/**
 一、NSRunLoop的实现机制,及在多线程中如何使用
 NSRunLoop是IOS消息机制的处理模式
 
 1.NSRunLoop的主要作用：控制NSRunLoop里面线程的执行和休眠，在有事情做的时候使当前NSRunLoop控制的线程工作，没有事情做让当前NSRunLoop的控制的线程休眠。
 
 2.NSRunLoop 就是一直在循环检测，从线程start到线程end，检测
 inputsource(如点击，双击等操作)异步事件，检测timesource同步事件，检测到输入源会执行处理函数，首先会产生通知，corefunction向线程添加runloop observers来监听事件，意在监听事件发生时来做处理。
 
 3.runloopmode是一个集合，包括监听：事件源，定时器，以及需通知的runloop observers
 
 只有在为你的程序创建次线程的时候，才需要运行runloop。对于程序的主线程而言，runloop是关键部分。Cocoa提供了运行主线程runloop的代码同时也会自动运行runloop。IOS程序UIApplication中的run方法在程序正常启动的时候就会启动runloop。如果你使用xcode提供的模板创建的程序，那你永远不需要自己去启动runloop
 在多线程中，你需要判断是否需要runloop。如果需要runloop，那么你要负责配置runloop并启动。你不需要在任何情况下都去启动runloop。比如，你使用线程去处理一个预先定义好的耗时极长的任务时，你就可以毋需启动runloop。Runloop只在你要和线程有交互时才需要 。
 二、IOS7之前,后台执行内容有几种形式,都是什么
 一般的应用在进入后台的时候可以获取一定时间来运行相关任务，也就是说可以在后台运行一小段时间(10S左右)。
 
 后台播放音乐
 后台GPS跟踪
 后台voip支持
 三、简单说一下 APP的启动过程,从 main文件开始说起
 程序启动分为两类:1.有storyboard2.没有storyboard
 
 有storyboard情况下:
 1.main函数
 2.UIApplicationMain
 创建UIApplication对象
 创建UIApplication的delegate对象
 3.根据Info.plist获得最主要storyboard的文件名,加载最主要的
 storyboard(有storyboard)
 创建UIWindow
 创建和设置UIWindow的rootViewController
 显示窗口
 
 没有storyboard情况下:
 1.main函数
 2.UIApplicationMain
 创建UIApplication对象
 创建UIApplication的delegate对象
 3.delegate对象开始处理(监听)系统事件(没有storyboard)
 程序启动完毕的时候, 就会调用代理的application:didFinishLaunchingWithOptions:方法在application:didFinishLaunchingWithOptions:中创建UIWindow创建和设置UIWindow的rootViewController
 显示窗口
 
 四、把程序自己关掉和程序进入后台,远程推送的区别
 关掉后不执行任何代码, 不能处理事件
 应用程序进入后台状态不久后转入挂起状态。在这种状态下，应用程序不执行任何代码，并有可能在任意时候从内存中删除。只有当用户再次运行此应用，应用才会从挂起状态唤醒，代码得以继续执行
 3.或者进入后台时开启多任务状态，保留在内存中，这样就可以执行系统允许的动作
 4.远程推送是由远程服务器上的程序发送到APNS,再由APNS把消息推送至设备上的程序,当应用程序收到推送的消息会自动调用特定的方法执行事先写好的代码
 五、本地通知和远程推送通知对基本概念和用法？
 本地通知和远程推送通知都可以向不在前台运行的应用发送消息,这种消息既可能是即将发生的事件,也可能是服务器的新数据.不管是本地通知还是远程通知,他们在程序界面的显示效果相同,都可能显示为一段警告信息或应用程序图标上的微章.
 本地通知和远程推送通知的基本目的都是让应用程序能够通知用户某些事情, 而且不需要应用程序在前台运行.二者的区别在于本地通知由本应用负责调用,只能从当前设备上的iOS发出, 而远程通知由远程服务器上的程序发送到APNS,再由APNS把消息推送至设备上的程序
 
 六、如果有人恶意重复注册账号，让我写一个接口,我怎么防止这样的事情。
 使用HTTPS,加时间戳1分钟内不允许重复发送, 短信验证, 判断手机号段保证号码正确,不是虚拟号吗. 保证邮箱,手机号等设备的标识唯一,并且在输入验证时判断,如果多次验证码错误.可以锁定账号或着手机注册.
 
 七、最常使用的地图是什么？
 国内：百度、高德
 国外：mapbox
 
 八、集成地图时都使用了哪些技术？
 使用地理编码和反编码进行地图定位，查找等功能，大头针的使用，路线查找。
 如果安卓和iOS用的不是同一个地图（比如安卓用的百度，iOS用的高德），需要做一套地图纠偏（国内的地图对应的经纬度都是有偏差的，称为“火星坐标”）
 
 九、集成地图有什么用？
 可以给用户更好的体验，使用苹果原生地图在位置定位的时候需要跟后台的数据进行转换，容易出错，因为一般后台用的都是百度或者高德地图，和苹果原生地图的坐标不同，就算转换后也容易出现偏差
 
 十、简单给出购物车的实现思路？
 iOS走近商城APP(五 购物车)
 
 十一、分析一下使用手机获取验证码注册账号的实现逻辑(给了一个示例图)，发送到手机的验证码超过60秒钟后重新发送
 定义一个 label属性，赋值为59秒在定义一个 count 设置一个timer每次减少一秒把count-- 再把 count 的值拼接到 label上当 count == 0 的时候在显示验证码输入
 
 */
@implementation JJiOSInterview06

@end
