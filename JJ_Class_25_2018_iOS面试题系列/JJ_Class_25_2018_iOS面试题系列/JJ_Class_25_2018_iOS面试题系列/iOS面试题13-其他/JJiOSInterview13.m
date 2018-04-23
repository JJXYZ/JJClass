//
//  JJiOSInterview13.m
//  JJ_Class_25_2018_iOS面试题系列
//
//  Created by Jay on 2018/4/23.
//  Copyright © 2018年 com.xiaoniu88.XNOnline. All rights reserved.
//

#import "JJiOSInterview13.h"


/**
 1.常用的设计模式
 单例模式
 组合模式
 观察者模式
 代理模式
 享元模式
 工厂方法模式
 抽象工厂模式
 
 2.MVC 的理解
 数据管理者(M)、数据展示者(V)、数据加工者(C)
 
 M 应该做的事：
 给 ViewController 提供数据
 给 ViewController 存储数据提供接口
 提供经过抽象的业务基本组件，供 Controller 调度
 
 C 应该做的事：
 管理 View Container 的生命周期
 负责生成所有的 View 实例，并放入 View Container
 监听来自 View 与业务有关的事件，通过与 Model 的合作，来完成对应事件的业务。
 
 V 应该做的事：
 响应与业务无关的事件，并因此引发动画效果，点击反馈（如果合适的话，尽量还是放在 View 去做）等。
 界面元素表达
 
 3.MVC 和 MVVM 的区别
 MVVM 是对胖模型进行的拆分，其本质是给控制器减负，将一些弱业务逻辑放到 VM 中处理
 
 MVC 是一切设计的基础，所有新的设计模式都是基于 MVC 进行的改进
 
 补充：常见的设计模式有：MVC、MVCS、MVVM、viper
 
 4.TCP 和 UDP 有什么区别？
 TCP 是面向连接的，建立连接需要经历三次握手，保证数据正确性和数据顺序
 
 UDP 是非连接的协议，传送数据受生成速度，传输带宽等限制，可能造成丢包
 
 UDP 一台服务端可以同时向多个客户端传输信息
 
 TCP 报头体积更大，对系统资源要求更多
 
 5.TCP 的三次握手
 第一次握手：客户端发送 syn 包到服务器，并进入 syn_send状态，等待服务器进行确认；
 
 第二次握手：服务器收到客户端的 syn 包，必须确认客户的SYN，同时自己也发送一个 SYN 包,即 SYN + ACK 包，此时服务器进入 SYN_RECV 状态;
 
 第三次握手：客户收到服务器发送的 SYN+ACK 包之后，向服务器发送确认包, 此包发送完毕，客户端和服务器进入ESTABLISHED 状态，完成第三次握手。
 
 6.如何制作一个静态库/动态库？他们的区别是什么？
 Xcode6 支持制作静态库/动态库 framework
 无论是动态库还是静态库都是区分真机和模拟器的静态库编译静态库文件装入程序空间，动态库是文件动态装入内存,动态库执行到相关函数才会被调用，节省空间 。
 
 苹果一般不允许第三方动态库，APP 容易被拒
 
 7. 一个 lib 包含了很多的架构，会打到最后的包里么？
 不会 ， 如果lib中有armv7,armv7s,arm64,i386,x86_64 架 构 ， 而 target architecture 选择了armv7s,arm64，那么只会从 lib 中 link 指定的这两个架构的二进制代码，其他架构下的代码不会 link 到最终可执行文件中；反过来，一个 lib 需要在模拟器环境中正常 link，也得包含 i386 架构的指令
 每一个设备都有属于自己的 CPU架构
 每一个静态支持的架构是固定的
 模拟器
 4s-->5 : i386
 5s-->6plus : x86_64
 
 真机
 3gs-->4s : armv7
 5/5c : armv7s,静态库只要支持了 armv7,就可以跑在 armv7s的架构上
 5s-->6plus : arm64
 
 8.常用命令总结：
 // 使用 lipo -info命令，查看指定库支持的架构，比如 UIKit框架
 lipo -info UIKit.framework/UIKit
 
 // 想看的更详细的信息可以使用 lipo -detailed_info
 lipo -detailed_info UIKit.framework/UIKit
 
 // 还可以使用 file命令
 file UIKit.framework/UIKit
 
 // 合并 MyLib-32.a和 MyLib-64.a，可以使用 lipo -create命令
 合并
 lipo -create MyLib-32.a MyLib-64.a -output MyLib.a
 
 9.支持 64-bit 后程序包会变大么？
 会，支持 64-bit 后，多了一个 arm64 架构，理论上每个架构一套指令，但相比原来会大多少还不好说
 
 10.用过 Core Data 或者 SQLite 吗？读写是分线程的吗？遇到过死锁没？如何解决的？
 用过 SQLite，使用 FMDB 框架
 丢给 FMDatabaseQueue 或者添加互斥锁（NSLock/@synchronized(锁对象)）
 
 11.请简单的介绍下 APNS 发送系统消息的机制
 APNS 优势：杜绝了类似安卓那种为了接受通知不停在后台唤醒程序保持长连接的行为，由 iOS 系统和 APNS 进行长连替代
 
 APNS 的原理：
 应用在通知中心注册，由 iOS 系统向 APNS 请求返回设备令牌(device Token)
 应用程序接收到设备令牌并发送给自己的后台服务器
 服务器把要推送的内容和设备发送给 APNS
 
 APNS 根据设备令牌找到设备，再由 iOS 根据 APPID 把推送内容展示
 
 12.不用中间变量,用两种方法交换 A 和 B 的值
 方法 1：A = A + B
 B = A - B
 A = A - B
 
 方法 2：异或 A = A^B;
 B = A^B;
 A = A^B;
 
 */
@implementation JJiOSInterview13

@end
