//
//  JJiOSInterview01.m
//  JJ_Class_25_2018_iOS面试题系列
//
//  Created by Jay on 2018/4/19.
//  Copyright © 2018年 com.xiaoniu88.XNOnline. All rights reserved.
//

#import "JJiOSInterview01.h"


/**
 一、多线程的底层实现？
 提示：
 1> 首先搞清楚什么是线程、什么是多线程
 2>Mach是第一个以多线程方式处理任务的系统，因此多线程的底层实现机制是基于Mach的线程
 3> 开发中很少用Mach级的线程，因为Mach级的线程没有提供多线程的基本特征，线程之间是独立的
 4> 开发中实现多线程的方案
 · C语言的POSIX接口：#include <pthread.h>
 · OC的NSThread
 · C语言的GCD接口（性能最好，代码更精简）
 · OC的NSOperation和NSOperationQueue（基于GCD）
 
 二、线程间怎么通信？
 
 performSelector:onThread:withObject:waitUntilDone:
 NSMachPort
 (基本机制：A线程（父线程）创建NSMachPort对象，并加入A线程的runloop。当创建B线程（辅助线程）时，将创建的NSMachPort对象传递到主体入口点，B线程（辅助线程）就可以使用相同的端口对象将消息传回A线程（父线程）。)
 
 
 三、网络图片处理问题中怎么解决一个相同的网络,地址重复请求的问题？
 提示：
 利用字典（图片地址为key，下载操作为value）
 
 四、用 NSOpertion 和 NSOpertionQueue 处理A,B,C三个线程,要求执行完 A,B后才能执行 C,怎么做？
 // 创建队列
 NSOperationQueue*queue=[[NSOperationQueue alloc] init];
 
 // 创建3个操作
 NSOperation*a= [NSBlockOperationblockOperationWithBlock:^{
 NSLog(@”operationA---“);
 }];
 NSOperation*b=[NSBlockOperationblockOperationWithBlock:^{
 NSLog(@”operationB---“);
 }];
 NSOperation*c=[NSBlockOperationblockOperationWithBlock:^{
 NSLog(@”operationC---“);
 }];
 
 // 添加依赖
 [caddDependency:a];
 [caddDependency:b];
 
 // 执行操作
 [queueaddOperation:a];
 [queueaddOperation:b];
 [queueaddOperation:c];
 五、列举 cocoa中常见对几种多线程的实现，并谈谈多线程安全的几种解决办法及多线程安全怎么控制？
 1> 只在主线程刷新访问UI
 2> 如果要防止资源抢夺，得用synchronized进行加锁保护
 3> 如果异步操作要保证线程安全等问题, 尽量使用GCD(有些函数默认
 就是安全的)
 
 六、GCD内部怎么实现的
 1> iOS和OS X的核心是XNU内核，GCD是基于XNU内核实现的
 2> GCD的API全部在libdispatch库中
 3> GCD的底层实现主要有Dispatch Queue和Dispatch Source
 · Dispatch Queue ：管理block(操作)
 · Dispatch Source ：处理事件
 
 七、你用过 NSOperationQueue么？如果用过或者了解的话，你为什么要使用 NSOperationQueue，实现了什么？请描述它和 GCD的区别和类似的地方（提示：可以从两者的实现机制和适用范围来描述）。
 1>GCD是纯C语言的API，NSOperationQueue是基于GCD的OC版本封装
 2>GCD只支持FIFO的队列，NSOperationQueue可以很方便地调整执行顺
 序、设置最大并发数量
 3>NSOperationQueue可以在轻松在Operation间设置依赖关系，而GCD
 需要写很多的代码才能实现
 4>NSOperationQueue支持KVO，可以监测operation是否正在执行
 （isExecuted）、是否结束（isFinished），是否取消（isCanceld）
 5>GCD的执行速度比NSOperationQueue快
 任务之间不太互相依赖：GCD
 任务之间有依赖\或者要监听任务的执行情况：NSOperationQueue
 
 八、 既然提到 GCD，那么问一下在使用 GCD以及block时要注意些什么？它们两是一回事儿么？block在 ARC中和传统的 MRC中的行为和用法有没有什么区别，需要注意些什么？
 Block的使用注意：
 1.block的内存管理
 2.防止循环retian
 · 非ARC（MRC）：__block
 · ARC：__weak__unsafe_unretained
 
 九、在异步线程中下载很多图片,如果失败了,该如何处理?请结合 RunLoop来谈谈解决方案.(提示:在异步线程中启动一个 RunLoop重新发送网络请求,下载图片)
 1> 重新下载图片
 2> 下载完毕, 利用RunLoop的输入源回到主线程刷新UIImageVIUew
 
 十、Socket的实现原理及 Socket之间是如何通信的
 网络上的两个程序通过一个双向的通信连接实现数据的交换，这个连接的一端称为一个socket。建立网络通信连接至少要一对端口号（socket）。socket本质是编程接口（API），对TCP/IP的封装，TCP/IP也要提供可供程序员做网络开发所用的接口，这就是Socket编程接口；HTTP是轿车，提供了封装或者显示数据的具体形式；Socket是发动机，提供了网络通信的能力。
 
 TCP,UDP和socket,Http之间联系和区别
 
 Socket通信原理简介
 
 Socket通信原理和实践
 
 十一、 http协议的实现
 http协议的实现
 
 HTTP协议：工作原理
 
 十二、什么是 TCP连接的三次握手
 第一次握手：客户端发送 syn 包(syn=j)到服务器，并进入 SYN_SEND 状态，等待服务器确认；
 第二次握手：服务器收到 syn 包，必须确认客户的 SYN（ack=j+1），同时自己也发送一个 SYN 包（syn=k），即 SYN+ACK 包，此时服务器进入 SYN_RECV 状态；
 第三次握手：客户端收到服务器的SYN＋ACK包，向服务器发送确认包ACK(ack=k+1)，此包发送完毕，客户端和服务器进入 ESTABLISHED 状态，完成三次握手。
 握手过程中传送的包里不包含数据，三次握手完毕后，客户端与服务器才正式开始传送数据。理想状态下，TCP 连接一旦建立，在通信双方中的任何一方主动关闭连接之前，TCP 连接都将被一直保持下去。断开连接时服务器和客户端均可以主动发起断开 TCP 连接的请求，断开过程需要经过“四次握手”（过程就不细写了，就是服务器和客户端交互，最终确定断开）
 
 
 见文件<TCP连接的三次握手.png>
 
 
 十三、http协议的组成和特性
 组成：http 请求由三部分组成，分别是：请求行、消息报头、请求正文 特性：HTTP协议的主要特点可概括如下：1.支持客户/服务器模式。2.简单快速：客户向服务器请求服务时，只需传送请求方法和路径。请求方法常用的有 GET、HEAD、POST。每种方法规定了客户与服务器联系的类型不同。由于 HTTP 协议简单，使得 HTTP 服务器的程序规模小，因而通信速度很快。3.灵活：HTTP 允许传输任意类型的数据对象。正在传输的类型由 Content-Type 加以标记。4.无连接：无连接的含义是限制每次连接只处理一个请求。服务器处理完客户的请求，并收到客户的应答后，即断开连接。采用这种方式可以节省传输时间。5.无状态：HTTP 协议是无状态协议。无状态是指协议对于事务处理没有记忆能力。缺少状态意味着如果后续处理需要前面的信息，则它必须重传，这样可能导致每次连接传送的数据量增大。另一方面，在服务器不需要先前信息时它的应答就较快。
 
 十四、在项目什么时候选择使用 GCD，什么时候选择NSOperation?
 项目中使用 NSOperation 的优点是 NSOperation 是对线程的高度抽象，在项目中使用它，会使项目的程序结构更好，子类化NSOperation 的设计思路，是具有面向对象的优点(复用、封装)，使得实现是多线程支持，而接口简单，建议在复杂项目中使用。项目中使用 GCD 的优点是 GCD 本身非常简单、易用，对于不复杂的多线程操作，会节省代码量，而 Block 参数的使用，会是代码更为易读，建议在简单项目中使用。
 
 十五、OC中的协议和 java中的接口概念有何不同？
 OBC 中的代理有 2 层含义，官方定义为 formal 和 informal protocol。前者和 Java接口一样。 informal protocol 中的方法属于设计模式考虑范畴，不是必须实现的，但是如果有实现，就会改变类的属性。 其实关于正式协议，类别和非正式协议我很早前学习的时候大致看过，也写在了学习教程里 “非正式协议概念其实就是类别的另一种表达方式“这里有一些你可能希望实现的方法，你可以使用他们更好的完成工作”。 这个意思是，这些是可选的。比如我门要一个更好的方法，我们就会申明一个这样的类别去实现。然后你在后期可以直接使用这些更好的方法。这么看，总觉得类别这玩意儿有点像协议的可选协议。" 现在来看，其实 protocal已经开始对两者都统一和规范起来操作，因为资料中说“非正式协议使用 interface修饰“， 现在我们看到协议中两个修饰词：“必须实现(@requied)”和“可选实现(@optional)”
 
 */
@implementation JJiOSInterview01

@end
