//
//  JJOCInterview4.m
//  JJ_Class_25_2018_iOS面试题系列
//
//  Created by Jay on 2018/4/19.
//  Copyright © 2018年 com.xiaoniu88.XNOnline. All rights reserved.
//

#import "JJOCInterview4.h"


/**
 1. Object-C有多继承吗？没有的话用什么代替？
 1> OC是单继承，没有多继承
 2> 有时可以用分类和协议来代替多继承
 
 2. Object-C有私有方法吗？私有变量呢？
 1> OC没有类似@private的修饰词来修饰方法，只要写在.h文件中，就是公共方法
 2> 如果你不在.h文件中声明，只在.m文件中实现，或在.m文件的Class Extension里声明，那么基本上和私有方法差不多，可以使用类扩展（Extension）来增加私有方法和私有变量
 3> 使用private修饰的全局变量是私有变量
 
 3. 关键字const什么含义？
 const int a;
 int const a;
 const int *a;
 int const *a;
 int * const a;
 int const * const a;
 1> 前两个的作用是一样：a 是一个常整型数
 2> 第三、四个意味着 a 是一个指向常整型数的指针(整型数是不可修改的，但指针可以)
 3> 第五个的意思：a 是一个指向整型数的常指针(指针指向的整型数是可以修改的，但指针是不可修改的)
 4> 最后一个意味着：a 是一个指向常整型数的常指针(指针指向的整型数是不可修改的，同时指针也是不可修改的)
 
 4. static的作用？
 1> static修饰的函数是一个内部函数，只能在本文件中调用，其他文件不能调用
 2> static修饰的全部变量是一个内部变量，只能在本文件中使用，其他文件不能使用
 3> static修饰的局部变量只会初始化一次，并且在程序退出时才会回收内存
 
 5. 线程和进程的区别？
 1> 一个应用程序对应一个进程，一个进程帮助程序占据一块存储空间。也有多个进程的应用（比如浏览器，多开几个页面）
 2> 要想在进程中执行任务，就必须开启线程，一条线程就代表一个任务
 3> 一个进程中允许开启多条线程，也就是同时执行多个任务
 
 6. 堆和栈的区别？
 1> 堆空间的内存是动态分配的，一般存放对象，并且需要手动释放内存
 2> 栈空间的内存由系统自动分配，一般存放局部变量等，不需要手动管理内存
 
 7. 为什么很多内置的类，如TableView的delegate的属性是assign不是retain？
 1> tableView的代理一般都是它所属的控制器，控制器会对它内部的view做一次retain操作
 2> 假设tableView也对代理（控制器）做一次retain操作，那么就出现循环retain问题
 
 8. 定义属性时，什么情况使用copy、assign、retain？
 1> copy：NSString、Block等类型
 2> assign：非OC对象类型， 基本数据类型（两个对象相互引用的时候，一端用retain， 一端用assign）
 3> retain：OC对象类型
 
 9. 对象是什么时候被释放的？
 每个对象都有一个引用计数器，每个新对象的计数器是1，当对象的计数器减为0时，就会被销毁
 
 10. tableView的重用机制？
 这里只是简述：将离开屏幕的cell放到缓存池，重新拿来显示到屏幕的其他位置（其他自己详细描述）
 
 11. ViewController 的loadView、viewDidLoad、viewDidUnload分别是什么时候调用的，在自定义ViewCointroller时在这几个函数中应该做什么工作？
 1> loadView
 当第一次使用控制器的view时，会调用loadView方法创建view
 一般在这里自定义view
 
 2> viewDidLoad
 当控制器的view创建完毕时会调用，也就是在loadView后调用
 一般在这里添加子控件、初始化数据
 
 3> viewDidUnload
 当控制器的view因为内存警告被销毁时调用
 一般在这里回收跟界面相关的资源（界面都会销毁了，跟界面相关的资源肯定不要了）
 
 12. ViewController的didReceiveMemoryWarning是在什么时候调用的？默认的操作是什么？
 当应用程序接收到系统的内容警告时，就有可能调用控制器的didRece…Warning方法
 它的默认做法是：
 当控制器的view不在窗口上显示时，就会直接销毁，并且调用viewDidUnload方法
 
 13. 怎么理解MVC，在Cocoa中MVC是怎么实现的？
 1> M：Model，模型，封装数据
 2> V：View，视图界面，负责展示数据
 3> C：Controller，控制器，负责提供数据（Model）给界面（View）
 
 14. self.跟self->什么区别？
 1> self.是调用get方法或者set放
 2> self是当前本身，是一个指向当前对象的指针
 3> self->是直接访问成员变量
 
 15. id、nil代表什么？
 1> id类型的指针可以指向任何OC对象
 2> nil代表空值（空指针的值， 0）
 
 16. 如何对iOS设备进行性能测试?
 Timer Profile
 
 */
@implementation JJOCInterview4

@end
