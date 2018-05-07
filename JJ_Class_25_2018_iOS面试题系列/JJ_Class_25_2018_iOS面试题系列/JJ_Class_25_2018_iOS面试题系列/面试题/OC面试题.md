###C语言面试题
* -1在内存里面是怎么存的
* ＃include <filename.h> 和 ＃include "filename.h" 
* 写一个宏MIN，这个宏输入两个参数并返回较小的一个
* 用变量a给出下面的定义  | 一个整型数 | 一个指向整型数的指针 | 一个指向指针的的指针，它指向的指针是指向一个整型数 | 一个有10个整型数的数组| 一个有10个指针的数组，该指针是指向一个整型数 | 一个指向有10个整型数数组的指针 | 一个指向函数的指针，该函数有一个整型参数并返回一个整型数 | 一个有10个指针的数组，该指针指向一个函数，该函数有一个整型参数并返回一个整型数 |
* 关键字static的作用是什么
* 关键字const是什么含意？ 分别解释下列语句中const的作用？
 | const int a; |   int const a; |   const int *a;   | int * const a;   | int const * a const; |   
* 下列交换方法swap
* 为什么标准头文件都有类似以下的结构？| ifndef | define | endif | UtilsMacro_h
* 堆和栈的区别？
* struct 和 class 的区别
* 在不用第三方参数的情况下，交换两个参数的值
* 局部变量能否和全局变量重名？ 
* 局部变量/全局变量/动态申请数据分别存在于哪里？
* 队列和栈有什么区别？用两个栈实现一个队列的功能？
* 进程和线程的区别。
* 数组和链表的区别
* 给出下列程序的结果. | char str1[] = "abc";    | char str2[] = "abc";    | const char str3[] = "abc";    | const char str4[] = "abc";    | const char *str5 = "abc";    | const char *str6 = "abc";    | char *str7 = "abc";    | char *str8 = "abc";    | cout < < ( str1 == str2 ) < < endl;   
* 排序方法：冒泡排序/选择法排序
* 链表，反转链表，双/单向链表/数组的区别

###OC面试题

* 属性(@property本质)(默认)/strong/weak(IBOutlet)/assign修饰符的区别/atomic一定线程安全/@synthesize和@dynamic/@synthesize合成实例变量的规则/copy/mutiblecopy/unsafe_unretained 
* +(void)load; +(void)initialize/调用时机
* OC的多继承
* OC如何对内存管理的，对象是什么时候被释放的。
* category的使用场景，继承和category使用时机，调用顺序
* autorelease的使用场景、autoreleasepool原理
* get和set方法手动内存管理。
* MRC和ARC(内部实现)区别,循环引用
* 使用 block时什么情况会发生循环引用，如何解决？block在ARC/MRC中的区别，内部原理/系统方法Block是否循环引用
* 线程/主线程/多线程,底层实现,OC中创建线程的几种方法,线程之间的通信,GCD的方法/内部实现/GCD的队列/废弃dispatch_get_current_queue/dispatch_barrier_async
* NSOperationQueue和GCD的区别
* A/B/C三个线程,执行完A,B后再执行C,顺/逆序
* GCD以及block时要注意些什么？ARC/MRC?
* 浅拷贝和深拷贝
* 分类/扩展类/继承
* KVO/KVC原理/手动触发KVO/自己动手实现KVO
* delegate/NSNotification(耗时操作)
* runtime理解/怎么添加属性/方法/调用方法的过程/method swizzling/[obj foo]和objc_msgSend()函数之间有什么关系/什么时候会报 unrecognized selector的异常/OC消息转发三部分
* RunLoop的理解/runloop和线程/runloop的mode/内部实现
* 简描元类和根类
* 推送原理/APNS发送系统消息的机制
* 单例,注意事项(MRC和ARC)
* 响应者链/事件传递
* frame/bounds
* method和selector区别
* 数据存储的方式
* tableView的重用机制
* ViewCointroller的生命周期
* MVC和MVVM
* self/self./self->
* iOS性能测试
* Socket的实现原理及Socket之间是如何通信的
* http(s)协议的实现/三次握手/HTTP协议中 POST方法和 GET方法有那些区别?/TCP 和 UDP 有什么区别
* Foundation对象与Core Foundation对象的区别
* 动态库/静态库
* CoreText简单介绍
* FMDB使用/多线程处理
* UIView/UIButton/CAAnimation层级结构，具体作用
* APP的启动过程,从 main文件开始说起
* 第三方框架/SDWebImage内部实现过程(缺点)/构建框架注意事项/AFN 与 ASI
* OC对象内存布局/isa的指针/[self/super class]/类方法和实例方法/Associate方法关联的对象/selector/IMP区别/
* BAD_ACCESS在什么情况下出现/如何调试
* 如果lib中有armv7,armv7s,arm64,i386,x86_64架构 
* 二叉树／平衡二叉树/冒泡排序/选择排序

###架构设计问题
* 如何看待APP从MVC切换到MVVM、VIPER、MVP多种框架的现状？
* MVC切换到MVVM使用ReactiveCocoa是为了什么，具体解决了什么问题？
* 系统库给我们提供了哪些设计模式？为提供的设计模式工作中使用到了哪些，解决了什么问题？
* Swift的POP、OC中的OOP，Swift的设计是为了解决什么痛点、难点？
* Swift的POP使用什么方式替代OOP中的继承和多态？

###网络相关问题
* HTTP、HTTPS的区别？
* HTTPS安全层的构建过程及实现？
* 简述几种对称、非对称加密方式？
* MD5和SHA-1两种编码方式的区别？
* Socket编程可以使用到的工具，CocoaAsyncSocket使用注意事项、场景？

###算法问题（可选其一）
* 有序链表如何找中位数？
* 内存中有1亿个数，如何取10个最小的数？（条件是有限使用最少的内存、最小复杂度。）
* 一个人在岛上走丢，找到岛上有一个搜救点信号点即可获救，手上有5个可接收信号设备，至少使用几个设备可以找到搜救点？（接收信号设备可以知道搜救点发出信号到接收到信号的距离。）

###其他问题
* 最近看了些什么技术书籍、学些了什么新的技术？
* 职业规划？
* 为什么选择小牛在线？
