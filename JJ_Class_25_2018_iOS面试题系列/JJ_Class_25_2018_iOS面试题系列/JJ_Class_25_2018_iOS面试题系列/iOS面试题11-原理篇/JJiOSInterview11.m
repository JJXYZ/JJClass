//
//  JJiOSInterview11.m
//  JJ_Class_25_2018_iOS面试题系列
//
//  Created by Jay on 2018/4/23.
//  Copyright © 2018年 com.xiaoniu88.XNOnline. All rights reserved.
//

#import "JJiOSInterview11.h"


/**
 1、runtime怎么添加属性、方法等
 ivar 表示成员变量
 class_addIvar
 class_addMethod
 class_addProperty
 class_addProtocol
 class_replaceProperty
 
 2 、是否可以把比较耗时的操作放在NSNotificationCenter中
 首先必须明确通知在哪个线程中发出，那么处理接受到通知的方法也在这个线
 程中调用
 如果在异步线程发的通知，那么可以执行比较耗时的操作；
 如果在主线程发的通知，那么就不可以执行比较耗时的操作
 
 3、runtime 如何实现 weak 属性
 首先要搞清楚 weak 属性的特点
 weak策略表明该属性定义了一种“非拥有关系” (nonowningrelationship)。
 为这种属性设置新值时，设置方法既不保留新值，也不释放旧值。此特质同 assign类似;然而在属性所指的对象遭到摧毁时，属性值也会清空(nil out)。
 那么 runtime 如何实现 weak 变量的自动置 nil？
 runtime 对注册的类，会进行布局，会将 weak 对象放入一个 hash 表中。用 weak 指向的对象内存地址作为 key，当此对象的引用计数为 0 的时候会调用对象的 dealloc 方法，假设 weak 指向的对象内存地址是 a，那么就会以 a 为 key，在这个 weak hash 表中搜索，找到所有以 a 为 key 的 weak 对象，从而设置为 nil。
 
 4、weak属性需要在 dealloc中置 nil么
 在 ARC 环境无论是强指针还是弱指针都无需在 dealloc 设置为 nil ， ARC 会自动帮我们处理，即便是编译器不帮我们做这些，weak 也不需要在 dealloc 中置 nil。在属性所指的对象遭到摧毁时，属性值也会清空。
 
 // 模拟下 weak的 setter方法，大致如下
 - (void)setObject:(NSObject *)object
 {
 objc_setAssociatedObject(self,  "object",   object,
 
 OBJC_ASSOCIATION_ASSIGN);
 [object cyl_runAtDealloc:^{
 _object = nil;
 }];
 }
 5、一个 Objective-C对象如何进行内存布局？（考虑有父类的情况）
 所有父类的成员变量和自己的成员变量都会存放在该对象所对应的存储空间中
 父类的方法和自己的方法都会缓存在类对象的方法缓存中，类方法是缓存在元类对象中
 每一个对象内部都有一个 isa指针,指向他的类对象,类对象中存放着本对象的如下信息
 
 对象方法列表
 成员变量的列表
 属性列表
 每个 Objective-C 对象都有相同的结构
 
 Objective-C 对象的结构图
 ISA指针
 根类(NSObject)的实例变量
 倒数第二层父类的实例变量
 ...
 父类的实例变量
 类的实例变量
 根类对象就是 NSObject，它的 super class 指针指向 nil
 类对象既然称为对象，那它也是一个实例。类对象中也有一个 isa 指针指向它的元类(meta class)，即类对象是元类的实例。元类内部存放的是类方法列表，根元类的 isa指针指向自己，superclass指针指向 NSObject类
 
 
 6、一个 objc对象的 isa的指针指向什么？有什么作用？
 每一个对象内部都有一个 isa 指针，这个指针是指向它的真实类型
 根据这个指针就能知道将来调用哪个类的方法
 
 7、下面的代码输出什么？
 @implementation Son : Father
 - (id)init
 {
 self = [super init];
 if (self) {
 NSLog(@"%@", NSStringFromClass([self class]));
 NSLog(@"%@", NSStringFromClass([super class]));
 }
 return self;
 }
 @end
 答案：都输出 Son
 这个题目主要是考察关于 objc 中对 self 和 super 的理解：
 self 是类的隐藏参数，指向当前调用方法的这个类的实例。而 super 本质是一个编译器标示符，和 self 是指向的同一个消息接受者，当使用 self 调用方法时，会从当前类的方法列表中开始找，如果没有，就从父类中再找；而当使用 super 时，则从父类的方法列表中开始找。然后调用父类的这个方法调用[self class] 时，会转化成 objc_msgSend 函数id objc_msgSend(id self, SELop, ...)。
 调用[super class] 时 ，会转化成objc_msgSendSuper函数id objc_msgSendSuper(struct objc_super *super, SEL op, ...)。
 第一个参数是objc_super 这样一个结构体，其定义如下
 
 struct objc_super {
 __unsafe_unretained id receiver;
 __unsafe_unretained Class super_class;
 };
 第一个成员是 receiver, 类似于上面的 objc_msgSend 函数第一个参数 self.
 第二个成员是记录当前类的父类是什么，告诉程序从父类中开始找方法，找到方法后，最后内部是使用 objc_msgSend(objc_super->receiver, @selector(class))去调用，此时已经和[self class]调用相同了，故上述输出结果仍然返回 Son objc Runtime 开源代码对- (Class)class 方法的实现
 
 -(Class)class {
 return object_getClass(self);
 }
 8、runtime如何通过 selector找到对应的 IMP地址？（分别考虑类方法和实例方法）
 每一个类对象中都一个对象方法列表（对象方法缓存）
 类方法列表是存放在类对象中 isa 指针指向的元类对象中（类方法缓存）
 方法列表中每个方法结构体中记录着方法的名称,方法实现,以及参数类型，其实selector 本质就是方法名称,通过这个方法名称就可以在方法列表中找到对应的方法实现.
 当我们发送一个消息给一个 NSObject 对象时，这条消息会在对象的类对象方法列表里查找,当我们发送一个消息给一个类时，这条消息会在类的 Meta Class 对象的方法列表里查找。
 
 9、objc中的类方法和实例方法有什么本质区别和联系
 类方法：
 类方法是属于类对象的
 类方法只能通过类对象调用
 类方法中的 self 是类对象
 类方法可以调用其他的类方法
 类方法中不能访问成员变量
 类方法中不能直接调用对象方法
 类方法是存储在元类对象的方法缓存中
 
 实例方法：
 实例方法是属于实例对象的
 实例方法只能通过实例对象调用
 实例方法中的 self 是实例对象
 实例方法中可以访问成员变量
 实例方法中直接调用实例方法
 实例方法中可以调用类方法(通过类名)
 实例方法是存放在类对象的方法缓存中
 
 10、使用 runtime Associate方法关联的对象，需要在主对象 dealloc的时候释放么？
 无论在 MRC 下还是 ARC 下均不需要
 被关联的对象在生命周期内要比对象本身释放的晚很多，它们会在被NSObject -dealloc 调用的 object_dispose()方法中释放。
 补充：对象的内存销毁时间表，分四个步骤
 1.调用 -release ：引用计数变为零
 
 对象正在被销毁，生命周期即将结束.
 不能再有新的 __weak 弱引用，否则将指向 nil.
 调用 [self dealloc]
 父类调用 -dealloc
 继承关系中最直接继承的父类再调用 -dealloc
 如果是 MRC 代码 则会手动释放实例变量们（iVars）
 继承关系中每一层的父类 都再调用 -dealloc
 NSObject 调 -dealloc
 只做一件事：调用 Objective-C runtime 中的 object_dispose() 方法
 调用 object_dispose()
 为 C++ 的实例变量们（iVars）调用 destructors
 为 ARC 状态下的 实例变量们（iVars） 调用 -release
 解除所有使用 runtime Associate 方法关联的对象
 解除所有 __weak 引用
 调用 free()
 11、_objc_msgForward函数是做什么的？直接调用它将会发生什么？
 _objc_msgForward 是 IMP 类型，用于消息转发的：当向一个对象发送一条消息，但它并没有实现的时候，_objc_msgForward 会尝试做消息转发。
 直接调用_objc_msgForward 是非常危险的事，这是把双刃刀，如果用不好会直接导致程序 Crash，但是如果用得好，能做很多非常酷的事。
 JSPatch 就是直接调用_objc_msgForward 来实现其核心功能的
 
 12、能否向编译后得到的类中增加实例变量？能否向运行时创建的类中添加实例变量？为什么？
 不能向编译后得到的类中增加实例变量；
 能向运行时创建的类中添加实例变量；
 
 分析如下：
 因为编译后的类已经注册在 runtime 中，类结构体中的 objc_ivar_list 实例变量的链表和 instance_size 实例变量的内存大小已经确定 ，同时runtime会调用class_setIvarLayout 或 class_setWeakIvarLayout 来处理 strong weak 引用，所以不能向存在的类中添加实例变量。
 运行时创建的类是可以添加实例变量，调用 class_addIvar 函数，但是得在调用objc_allocateClassPair 之后，objc_registerClassPair 之前，原因同上。
 13、runloop和线程有什么关系？
 每条线程都有唯一的一个 RunLoop 对象与之对应的
 主线程的 RunLoop 是自动创建并启动
 子线程的 RunLoop 需要手动创建
 子线程的 RunLoop 创建步骤如下：
 在子线程中调用[NSRunLoop currentRunLoop]创建 RunLoop 对象（懒加载，只创建一次）。
 获得 RunLoop 对象后要调用 run方法来启动一个运行循环
 
 // 启动 RunLoop
 [[NSRunLoop currentRunLoop] run];
 RunLoop 的其他启动方法 // 第一个参数：指定运行模式
 // 第二个参数：指定 RunLoop 的过期时间，即：到了这个时间后
 RunLoop就失效了
 [[NSRunLoop currentRunLoop] runMode:kCFRunLoopDefaultMode
 beforeDate:[NSDate distantFuture]];
 14、runloop的 mode作用是什么？
 用来控制一些特殊操作只能在指定模式下运行，一般可以通过指定操作的运行。
 mode 来控制执行时机，以提高用户体验
 
 系统默认注册了 5 个 Mode
 1.kCFRunLoopDefaultMode：App 的默认 Mode，通常主线程是在这个 Mode下运行，对应 OC 中的：NSDefaultRunLoopMode
 2.UITrackingRunLoopMode：界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响
 3.kCFRunLoopCommonModes:这是一个标记 Mode，不是一种真正的 Mode，事件可 以 运 行 在 所 有 标 有 common modes 标 记 的 模 式 中 ， 对 应 OC 中 的NSRunLoopCommonModes ， 带 有 common modes 标 记 的 模 式 有 ：UITrackingRunLoopMode 和 kCFRunLoopDefaultMode
 4.UIInitializationRunLoopMode：在启动 App 时进入的第一个 Mode，启动完成后就不再使用
 5.GSEventReceiveRunLoopMode：接受系统事件的内部 Mode，通常用不到
 15、以+scheduledTimerWithTimeInterval...的方式触发的 timer，在滑动页面上的列表时，timer会暂定回调，为什么？如何解决？
 这里强调一点：在主线程中以+scheduledTimerWithTimeInterval...的方式触发的timer 默认是运行在 NSDefaultRunLoopMode模式下的，当滑动页面上的列表时，进入了 UITrackingRunLoopMode模式，这时候 timer 就会停止。可以修改 timer 的运行模式为 NSRunLoopCommonModes，这样定时器就可以一直运行了。
 以下是我的补充：
 在子线程中通过 scheduledTimerWithTimeInterval:...方法来构建
 NSTimer方法内部已经创建NSTimer 对象 ，并加入到 RunLoop 中 ， 运行模式为NSDefaultRunLoopMode。
 由于 Mode 有 timer 对象，所以 RunLoop 就开始监听定时器事件了，从而开始进入运行循环。
 这个方法仅仅是创建 RunLoop 对象，并不会主动启动 RunLoop，需要再调用 run方法来启动
 如果在主线程中通过 scheduledTimerWithTimeInterval:...方法来构
 建 NSTimer，就不需要主动启动 RunLoop 对象，因为主线程的 RunLoop 对象在程序运行起来就已经被启动了
 
 // userInfo 参数：用来给 NSTimer 的
 userInfo属性赋值，userInfo是只读的，只能在构建 NSTimer对象
 时赋值
 [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
 selector:@selector(run:)    userInfo:@"ya了个hoo"
 repeats:YES];
 
 //scheduledTimer...方法创建出来 NSTimer虽然已经指定了默认模
 式，但是【允许你修改模式】
 [[NSRunLoop currentRunLoop] addTimer:timer
 forMode:NSRunLoopCommonModes];
 
 // 【仅在子线程】需要手动启动 RunLoop对象，进入运行循环
 [[NSRunLoop currentRunLoop] run];
 16、猜想 runloop内部是如何实现的？
 从字面意思看：运行循环、跑圈；
 本质：内部就是 do-while循环，在这个循环内部不断地处理各种事件(任务)，
 比如：Source、Timer、Observer；
 每条线程都有唯一一个 RunLoop 对象与之对应，主线程的 RunLoop 默认已经启动，子线程的 RunLoop 需要手动启动；
 每次 RunLoop 启动时，只能指定其中一个 Mode，这个 Mode 被称作 CurrentMode，如果需要切换 Mode，只能退出 Loop，再重新指定一个 Mode 进入，这样做主要是为了隔离不同 Mode 中的 Source、Timer、Observer，让其互不影响；
 附上RunLoop的运行图
 
 
 17、不手动指定 autoreleasepool的前提下，一个 autorealese对象在什么时刻释放？（比如在一个 vc的 viewDidLoad中创建）
 分两种情况：手动干预释放时机、系统自动去释放
 手动干预释放时机：指定 autoreleasepool 就是所谓的：当前作用域大括号结束时就立即释放
 系统自动去释放：不手动指定 autoreleasepool，Autorelease 对象会在当前的runloop 迭代结束时释放，下面详细说明释放时机
 RunLoop 中的三个状态会处理自动释放池，通过打印代码发现有两个 Observer 监听到状态值为：1 和 160（32+128）
 
 kCFRunLoopEntry(1)// 第一次进入会创建一个自动释放池kCFRunLoopBeforeWaiting(32)// 进入休眠状态前先销毁自动释放池，
 再创建一个新的自动释放池
 kCFRunLoopExit(128)// 退出 RunLoop 时销毁最后一次创建的自动释放池
 如果在一个 vc 的 viewDidLoad 中创建一个 Autorelease 对象，那么该对象会在viewDidAppear 方法执行前就被销毁了（是这样的吗？？？）
 
 18、苹果是如何实现 autoreleasepool的？
 autoreleasepool 以一个队列数组的形式实现,主要通过下列三个函数完成.
 objc_autoreleasepoolPush
 objc_autoreleasepoolPop
 objc_aurorelease
 看函数名就可以知道，对 autorelease 分别执行 push，和 pop 操作。销毁对象时执行 release 操作
 
 19、GCD的队列（dispatch_queue_t）分哪两种类型？背后的线程模型是什么样的？
 串行队列
 并行队列
 dispatch_global_queue();是全局并发队列
 dispatch_main_queue();是一种特殊串行队列
 背后的线程模型：自定义队列 dispatch_queue_t queue; 可以自定义是并行：
 DISPATCH_QUEUE_CONCURRENT 或者 串行 DISPATCH_QUEUE_SERIAL
 
 20、苹果为什么要废弃dispatch_get_current_queue？
 容易误用造成死锁
 
 21如何用 GCD同步若干个异步调用？（如根据若干个 url异步加载多张图片，然后在都下载完成后合成一张整图）
 必须是并发队列才起作用
 需求分析
 首先，分别异步执行 2 个耗时的操作
 其次，等 2 个异步操作都执行完毕后，再回到主线程执行一些操作使用队列组实现上面的需求
 
 // 创建队列组
 dispatch_group_t group =    dispatch_group_create();
 
 // 获取全局并发队列
 dispatch_queue_t    queue   =
 dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 
 // 往队列组中添加耗时操作
 
 dispatch_group_async(group, queue, ^{
 // 执行耗时的异步操作 1
 });
 
 // 往队列组中添加耗时操作
 dispatch_group_async(group, queue, ^{
 // 执行耗时的异步操作 2
 });
 
 // 当并发队列组中的任务执行完毕后才会执行这里的代码
 dispatch_group_notify(group, queue, ^{
 // 如果这里还有基于上面两个任务的结果继续执行一些代码，建议还是放到子
 线程中，等代码执行完毕后在回到主线程
 
 // 回到主线程
 dispatch_async(group, dispatch_get_main_queue(), ^{
 // 执行相关代码...
 });
 });
 22、dispatch_barrier_async的作用是什么？
 函数定义
 dispatch_barrier_async(dispatch_queue_t queue,
 dispatch_block_t block);
 必须是并发队列，要是串行队列，这个函数就没啥意义了
 注意：这个函数的第一个参数 queue 不能是全局的并发队列
 作用：在它前面的任务执行结束后它才执行，在它后面的任务等它执行完成后才会执行。
 示例代码
 
 -(void)barrier
 {
 dispatch_queue_t    queue   =   dispatch_queue_create("12342234",
 DISPATCH_QUEUE_CONCURRENT);
 
 dispatch_async(queue, ^{
 NSLog(@"----1-----%@", [NSThread currentThread]);
 });
 dispatch_async(queue, ^{
 NSLog(@"----2-----%@", [NSThread currentThread]);
 });
 
 // 在它前面的任务执行结束后它才执行，在它后面的任务等它执行完成后才会
 执行
 dispatch_barrier_async(queue, ^{
 NSLog(@"----barrier-----%@", [NSThread currentThread]);
 });
 
 dispatch_async(queue, ^{
 NSLog(@"----3-----%@", [NSThread currentThread]);
 });
 dispatch_async(queue, ^{
 NSLog(@"----4-----%@", [NSThread currentThread]);
 });
 }
 23、以下代码运行结果如何？
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 NSLog(@"1");
 dispatch_sync(dispatch_get_main_queue(), ^{
 NSLog(@"2");
 });
 NSLog(@"3");
 }
 答案：主线程死锁
 
 24、lldb（gdb）常用的调试命令？
 po：打印对象，会调用对象 description 方法。是 print-object 的简写
 expr：可以在调试时动态执行指定表达式，并将结果打印出来，很有用的命令
 print：也是打印命令，需要指定类型
 bt：打印调用堆栈，是 thread backtrace 的简写，加 all 可打印所有 thread 的堆栈
 brl：是 breakpoint list 的简写
 
 25、BAD_ACCESS在什么情况下出现？
 访问一个僵尸对象，访问僵尸对象的成员变量或者向其发消息死循环
 
 26、如何调试 BAD_ACCESS错误
 设置全局断点快速定位问题代码所在行
 开启僵尸对象调试功能
 
 
 
 27、简述下 Objective-C 中调用方法的过程（runtime）
 Objective-C 是动态语言，每个方法在运行时会被动态转为消息发送，即：objc_msgSend(receiver, selector)，整个过程介绍如下：
 objc 在向一个对象发送消息时，runtime 库会根据对象的 isa 指针找到该对象实际所属的类
 然后在该类中的方法列表以及其父类方法列表中寻找方法运行，如果，在最顶层的父类（一般也就 NSObject）中依然找不到相应的方法时，程序在运行时会挂掉并抛出异常 unrecognized selector sent to XXX
 但是在这之前，objc 的运行时会给出三次拯救程序崩溃的机会，这三次拯救程序奔溃的说明见问题《什么时候会报 unrecognized selector 的异常》中的说明。
 补充说明：Runtime 铸就了 Objective-C 是动态语言的特性，使得 C 语言具备了面向对象的特性，在程序运行期创建，检查，修改类、对象及其对应的方法，这些操作都可以使用 runtime 中的对应方法实现。
 
 28、什么是 method swizzling（俗称黑魔法）
 简单说就是进行方法交换
 在 Objective-C 中调用一个方法，其实是向一个对象发送消息，查找消息的唯一依据是 selector 的名字。利用 Objective-C 的动态特性，可以实现在运行时偷换 selector 对应的方法实现，达到给方法挂钩的目的
 每个类都有一个方法列表，存放着方法的名字和方法实现的映射关系，selector 的本质其实就是方法名，IMP 有点类似函数指针，指向具体的 Method 实现，通过selector 就可以找到对应的IMP
 
 
 交换方法的几种实现方式
 利用 method_exchangeImplementations 交换两个方法的实现
 利用 class_replaceMethod 替换方法的实现
 利用 method_setImplementation来直接设置某个方法的IMP
 
 
 29、objc中向一个 nil对象发送消息将会发生什么？
 在 Objective-C 中向 nil 发送消息是完全有效的——只是在运行时不会有任何作用
 如果一个方法返回值是一个对象，那么发送给 nil 的消息将返回 0(nil)
 如果方法返回值为指针类型，其指针大小为小于或者等于 sizeof(void*)
 float，double，long double 或者 long long 的整型标量，发送给 nil 的消息将返回 0
 如果方法返回值为结构体,发送给 nil 的消息将返回 0。结构体中各个字段的值将都是 0
 如果方法的返回值不是上述提到的几种情况，那么发送给 nil 的消息的返回值将是未定义的
 具体原因分析
 objc 是动态语言 ，每个方法在运行时会被动态转为消息发送，即 ：
 objc_msgSend(receiver, selector)
 为了方便理解这个内容，还是贴一个 objc 的源代码
 
 struct objc_class
 {
 // isa 指针指向 Meta Class，因为 Objc 的类的本身也是一个 Object，
 // 为了处理这个关系，runtime 就创造了 Meta Class，
 // 当给类发送[NSObject alloc]这样消息时，实际上是把这个消息发给了 Class
 Object
 Class isa OBJC_ISA_AVAILABILITY;
 #if !__OBJC2__
 Class super_class OBJC2_UNAVAILABLE; // 父类
 const char *name OBJC2_UNAVAILABLE; // 类名
 long version OBJC2_UNAVAILABLE; // 类的版本信息，默认为 0
 long info OBJC2_UNAVAILABLE; // 类信息，供运行期使用的一些位标识
 long instance_size OBJC2_UNAVAILABLE; // 该类的实例变量大小
 struct objc_ivar_list *ivars OBJC2_UNAVAILABLE; // 该类的成员变量链表
 struct objc_method_list **methodLists OBJC2_UNAVAILABLE; // 方法定义的链表
 // 方法缓存，对象接到一个消息会根据 isa 指针查找消息对象，
 // 这时会在 method Lists 中遍历，
 // 如果 cache 了，常用的方法调用时就能够提高调用的效率。
 // 这个方法缓存只存在一份，不是每个类的实例对象都有一个方法缓存
 // 子类会在自己的方法缓存中缓存父类的方法，父类在自己的方法缓存中也会缓存
 自己的方法，而不是说子类就不缓存父类方法了
 struct objc_cache *cache OBJC2_UNAVAILABLE;
 struct objc_protocol_list *protocols OBJC2_UNAVAILABLE; // 协议链表
 #endif
 } OBJC2_UNAVAILABLE;
 objc 在向一个对象发送消息时，runtime 库会根据对象的 isa 指针找到该对象实际所属的类，然后在该类中的方法列表以及其父类方法列表中寻找方法运行，然后再发送消息的时候，objc_msgSend 方法不会返回值，所谓的返回内容都是具体调用时执行的。
 如果向一个 nil 对象发送消息，首先在寻找对象的 isa 指针时就是 0 地址返回了，所以不会出现任何错误
 
 30、objc 中向一个对象发送消息[obj foo]和objc_msgSend()函数之间有什么关系？
 [obj foo];在 objc 动态编译时，会被转意为：objc_msgSend(obj,@selector(foo));
 
 31、什么时候会报 unrecognized selector的异常？
 当调用该对象上某个方法,而该对象上没有实现这个方法的时候， 可以通过“消息转发”进行解决，如果还是不行就会报 unrecognized selector 异常
 objc 是 动 态 语 言 ， 每 个 方 法 在 运 行 时 会 被 动 态 转 为 消 息 发 送 ， 即 ：
 objc_msgSend(receiver, selector)，整个过程介绍如下：
 objc 在向一个对象发送消息时，runtime 库会根据对象的 isa 指针找到该对象实际所属的类
 然后在该类中的方法列表以及其父类方法列表中寻找方法运行
 如果，在最顶层的父类中依然找不到相应的方法时，程序在运行时会挂掉并抛出异常 unrecognized selector sent to XXX 。但是在这之前，objc 的运行时会给出三次拯救程序崩溃的机会
 
 三次拯救程序崩溃的机会
 
 Method resolution
 objc运行时会调用+resolveInstanceMethod: 或者+resolveClassMethod:，让你有机会提供一个函数实现。
 如果你添加了函数并返回 YES，那运行时系统就会重新启动一次消息发送的过程
 如果 resolve 方法返回 NO ，运行时就会移到下一步，消息转发
 Fast forwarding
 如果目标对象实现了-forwardingTargetForSelector:，Runtime 这时就会调用这个方法，给你把这个消息转发给其他对象的机会
 只要这个方法返回的不是 nil和 self，整个消息发送的过程就会被重启，当然发送的对象会变成你返回的那个对象。否则，就会继续 Normal Fowarding。这里叫 Fast，只是为了区别下一步的转发机制。因为这一步不会创建任何新的对象，但 Normal forwarding 转发会创建一个 NSInvocation 对象，相对 Normal forwarding 转发更快点，所以这里叫 Fast forwarding
 Normal forwarding
 这一步是 Runtime 最后一次给你挽救的机会。
 首先它会发送-methodSignatureForSelector:消息获得函数的参数和返回值类型。
 如果 -methodSignatureForSelector:返回nil，Runtime则会发出
 -doesNotRecognizeSelector:消息，程序这时也就挂掉了。
 如果返回了一个函数签名，Runtime 就会创建一个 NSInvocation 对象并发送-forwardInvocation:消息给目标对象
 32、HTTP协议中 POST方法和 GET方法有那些区别?
 .先说一个不正确的理解：GET 用于向服务器请求数据，POST 用于提交数据，这样说是不对的，GET也可以提交数据，POST也可以请求数据。
 你轻轻松松的给出了一个“标准答案”：
 
 GET在浏览器回退时是无害的，而POST会再次提交请求。
 GET产生的URL地址可以被Bookmark，而POST不可以。
 GET请求会被浏览器主动cache，而POST不会，除非手动设置。
 GET请求只能进行url编码，而POST支持多种编码方式。
 GET请求参数会被完整保留在浏览器历史记录里，而POST中的参数不会被保留。
 GET请求在URL中传送的参数是有长度限制的，而POST么有。
 对参数的数据类型，GET只接受ASCII字符，而POST没有限制。
 GET比POST更不安全，因为参数直接暴露在URL上，所以不能用来传递敏感信息。
 GET参数通过URL传递，POST放在Request body中。
 （本标准答案参考自w3schools）
 “很遗憾，这不是我们要的回答！”
 如果我告诉你GET和POST本质上没有区别你信吗？
 让我们扒下GET和POST的外衣，坦诚相见吧！
 
 GET和POST是什么？HTTP协议中的两种发送请求的方法。
 HTTP是什么？HTTP是基于TCP/IP的关于数据如何在万维网中如何通信的协议。
 HTTP的底层是TCP/IP。所以GET和POST的底层也是TCP/IP，也就是说，GET/POST都是TCP链接。GET和POST能做的事情是一样一样的。你要给GET加上request body，给POST带上url参数，技术上是完全行的通的。
 
 HTTP只是个行为准则，而TCP才是GET和POST怎么实现的基本
 
 GET和POST本质上就是TCP链接，并无差别。但是由于HTTP的规定和浏览器/服务器的限制，导致他们在应用过程中体现出一些不同
 
 GET和POST还有一个重大区别
 简单的说：
 GET产生一个TCP数据包；POST产生两个TCP数据包。
 长的说：
 对于GET方式的请求，浏览器会把http header和data一并发送出去，服务器响应200（返回数据）；
 而对于POST，浏览器先发送header，服务器响应100 continue，浏览器再发送data，服务器响应200 ok（返回数据）。
 注意 ：并不是所有浏览器都会在POST中发送两次包，Firefox就只发送一次。
 
 33、使用 block时什么情况会发生引用循环，如何解决？
 一个对象中强引用了block，在block中又强引用了该对象，就会发射循环引用。
 解决方法是将该对象使用__weak或者__block修饰符修饰之后再在block中使用。
 
 id __weak weakSelf = self; 或者 __weak __typeof(self)weakSelf = self;. 该方法可以设置宏
 id __block weakSelf = self;
 或者将其中一方强制制空 xxx = nil。
 
 检测代码中是否存在循环引用问题，可使用 Facebook 开源的一个检测工具 FBRetainCycleDetector 。
 
 34、在 block内如何修改 block外部变量？
 __block int a = 0;
 void (^foo)(void) = ^{
 a = 1;
 };
 foo(); //这里，a的值被修改为1
 35、使用系统的某些 block api（如 UIView的block版本写动画时），是否也考虑循环引用问题？
 系统的某些 block api 中，UIView 的 block 版本写动画时不需要考虑，但也有一些 api 需要考虑
 以下这些使用方式不会引起循环引用的问题
 
 [UIView animateWithDuration:duration animations:^
 { [self.superview layoutIfNeeded]; }];
 
 [[NSOperationQueue mainQueue] addOperationWithBlock:^
 { self.someProperty = xyz; }];
 
 [[NSNotificationCenter defaultCenter] addObserverForName:@"someNotification"
 object:nil
 queue:[NSOperationQueue mainQueue]
 usingBlock:^(NSNotification * notification)
 { self.someProperty = xyz; }];
 但如果方法中的一些参数是    成员变量，那么可以造成循环引用，如   GCD 、
 NSNotificationCenter 调用就要小心一点，比如 GCD 内部如果引用了 self，而且
 GCD 的参数是 成员变量，则要考虑到循环引用，举例如下：
 GCD
 分析：self-->_operationsQueue-->block-->self 形成闭环，就造成了循环引用__weak
 __typeof__(self) weakSelf = self;
 dispatch_group_async(_operationsGroup, _operationsQueue, ^
 {
 [weakSelf doSomething];
 [weakSelf doSomethingElse];
 } );
 
 NSNotificationCenter
 分析：self-->_observer-->block-->self 形成闭环，就造成了循环引用
 __weak __typeof__(self) weakSelf = self;
 _observer = [[NSNotificationCenter defaultCenter]
 addObserverForName:@"testKey"
 object:nil
 queue:nil
 usingBlock:^(NSNotification *note){
 [weakSelf dismissModalViewControllerAnimated:YES];
 }];
 
 */
@implementation JJiOSInterview11

@end
