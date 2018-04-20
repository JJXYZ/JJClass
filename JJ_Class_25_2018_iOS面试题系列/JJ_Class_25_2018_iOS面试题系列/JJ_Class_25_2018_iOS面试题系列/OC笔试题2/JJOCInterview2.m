//
//  JJOCInterview2.m
//  JJ_Class_25_2018_iOS面试题系列
//
//  Created by Jay on 2018/4/19.
//  Copyright © 2018年 com.xiaoniu88.XNOnline. All rights reserved.
//

#import "JJOCInterview2.h"


/**
 1. Difference between shallow copy and deep copy?
 1> 浅拷贝：指针（地址）拷贝，不会产生新对象
 2> 深拷贝：内容拷贝，会产生新对象
 
 2. What is advantage of categories? What is difference between implementing a category and inheritance?
 1> 分类可以在不修改原来类模型的基础上拓充方法
 2> 分类只能扩充方法、不能扩充成员变量；继承可以扩充方法和成员变量
 3> 继承会产生新的类
 
 3. Difference between categories and extensions?
 1> 分类是有名称的，类扩展没有名称
 2> 分类只能扩充方法、不能扩充成员变量；类扩展可以扩充方法和成员变量
 3> 类扩展一般就写在.m文件中，用来扩充私有的方法和成员变量（属性）
 
 4. Difference between protocol in objective c and interfaces in java?
 1> Java的接口中声明的方法必须都实现
 2> Oc的protocol中声明的方法并不一定要实现
 
 5. What are KVO and KVC?
 1> KVC是键值编码，可以通过一个字符串的key（属性名）修改对象的属性值
 2> KVO是键值监听，可以监听一个对象属性值的改变
 
 6. What is purpose of delegates?
 1> 两个对象之间传递数据和消息
 2> 解耦，拆分业务逻辑
 
 7. What are mutable and immutable types in Objective C?
 1> mutable是可变类型，比如NSMutableArray，可以动态往里面添加元素
 2> immutable是不可变类型，比如NSArray，固定的存储空间，不能添加元素
 
 8. When we call objective c is runtime language what does it mean?
 1> 动态绑定：对象类型在运行时才真正确定
 2> 多态性
 3> 消息机制
 
 9. what is difference between NSNotification and protocol?
 1> 通过NSNotification可以给多个对象传递数据和消息
 2> 通过protocol（代理模式）只能给一个对象传递数据和消息
 
 10. What is push notification?
 1> 本地推送：程序内部弹出通知到用户设备
 2> 远程推送：由推送服务器推送通知到用户设备
 
 11. What is Polymorphism？
 多态：父类指针指向子类对象
 
 12. What is Singleton?
 单粒：保证程序运行过程中，永远只有一个对象实例
 目的是：全局共享一份资源、节省不必要的内存开销
 
 13. What is responder chain?
 响应者链：
 λ UIResponder有一个nextResponder属性，通过该属性可以组成一个响应者链，事件或消息在其路径上进行传递
 λ 如果UIResponder没有处理传给它的事件，会将未处理的消息转发给自己的nextResponder
 
 14. Difference between frame and bounds?
 1> frame以父控件的左上角为坐标原点
 2> bounds以控件本身的左上角为坐标原点
 
 15. Difference between method and selector?
 通过一个selector可以找到方法地址，进而调用一个方法
 
 16. Is there any garbage collection mechanism in Objective C.?
 1> OC 1.0没有垃圾回收
 2> OC 2.0有垃圾回收，只能用在Mac上
 3> iOS中有ARC机制，是编译器特性，垃圾回收是运行时特性
 
 17. What is NSOperation queue?
 1> 用来存放NSOperation对象的队列，可以用来异步执行一些操作
 2> 一般可以用在网络请求等耗时操作
 
 18. What is lazy loading?
 延迟加载：比如控制器的view，在第一次用到view时才会调用loadView方法进行创建
 
 19. Can we use two tableview controllers on one viewcontroller?
 从技术角度上分析，一个控制器内部添加2个表格控制器是没有问题的
 
 20. Can we use one tableview with two different datasources? How you will achieve this?
 从对象属性上分析，tableView只有一个dataSource属性。当然，真要使用2个不同的数据源，还是有其他办法解决的
 
 */
@implementation JJOCInterview2

@end
