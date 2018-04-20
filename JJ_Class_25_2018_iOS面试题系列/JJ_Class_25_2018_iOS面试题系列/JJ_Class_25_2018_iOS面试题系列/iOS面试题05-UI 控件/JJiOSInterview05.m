//
//  JJiOSInterview05.m
//  JJ_Class_25_2018_iOS面试题系列
//
//  Created by Jay on 2018/4/19.
//  Copyright © 2018年 com.xiaoniu88.XNOnline. All rights reserved.
//

#import "JJiOSInterview05.h"


/**
 一、怎么解决缓存池满的问题(cell)
 ios中不存在缓存池满的情况，因为通常我们ios中开发，对象都是在需要的时候才会创建，有种常用的说话叫做懒加载，还有在UITableView中一般只会创建刚开始出现在屏幕中的cell，之后都是从缓存池里取，不会在创建新对象。缓存池里最多也就一两个对象，缓存池满的这种情况一般在开发java中比较常见，java中一般把最近最少使用的对象先释放。
 
 二、CAAnimation的层级结构
 
 三、UIButton与 UITableView的层级结构
 · 继承结构
 · 内部的子控件结构
 
 四、如何渲染自定义格式字符串的 UILabel
 通过NSAttributedString类
 
 五 、设置scroll view的contensize 能在Viewdidload里设置么,为什么
 能
 
 六、按钮或者其它 UIView控件的事件传递的具体过程
 触摸事件的传递是从父控件传递到子控件也就是UIApplication->window->寻找处理事件最合适的view
 注 意: 如果父控件不能接受触摸事件，那么子控件就不可能接收到触摸事件
 应用如何找到最合适的控件来处理事件？
 1.首先判断主窗口（keyWindow）自己是否能接受触摸事件
 2.判断触摸点是否在自己身上
 3.子控件数组中从后往前遍历子控件，重复前面的两个步骤（所谓从后往前遍历子控件，就是首先查找子控件数组中最后一个元素，然后执行1、2步骤）
 4.view，比如叫做fitView，那么会把这个事件交给这个fitView，再遍历这个fitView的子控件，直至没有更合适的view为止。
 5.如果没有符合条件的子控件，那么就认为自己最合适处理这个事件，也就是自己是最合适的view。
 
 UIView不能接收触摸事件的三种情况：
 
 不允许交互：userInteractionEnabled = NO
 隐藏：如果把父控件隐藏，那么子控件也会隐藏，隐藏的控件不能接受事件
 透明度：如果设置一个控件的透明度<0.01，会直接影响子控件的透明度。alpha：0.0~0.01为透明。
 注 意:默认UIImageView不能接受触摸事件，因为不允许交互，即userInteractionEnabled = NO。所以如果希望UIImageView可以交互，需要设置UIImageView的userInteractionEnabled = YES。
 史上最详细的iOS之事件的传递和响应机制-原理篇
 
 七、控制器 View的生命周期及相关函数是什么？你在开发中是如何用的？
 1.首先判断控制器是否有视图，如果没有就调用loadView方法创建：通过storyboard或者代码；
 2.随后调用viewDidLoad，可以进行下一步的初始化操作；只会被调用一次；
 3.在视图显示之前调用viewWillAppear；该函数可以多次调用；
 4.视图viewDidAppear
 5.在视图消失之前调用viewWillDisappear；该函数可以多次调用；
 如需要）；
 6.在布局变化前后，调用viewWill/DidLayoutSubviews处理相关信息；
 八、简单说一下时间响应的流程？
 ①一个 UIView 发出一个事件之后，首先上传给其父视图;②父视图上传给其所在的控制器;③如果其控制器对事件进行处理，事件传递将终止，否则继续上传父视图;④直到遇到响应者才会停止，否则事件将一直上传，直到 UIWindow。
 
 九、UIscrollVew用到了什么设计模式？还能再foundation库中找到类似的吗？
 模板模式，所有 datasource 和 delegate 接口都是模板模式的典型应用，组合模式composition，所有的 containerview 都用了这个模式观察者模式 observer，所有的 UIResponder 都用了这个模式
 
 十、动态绑定—在运行时确定要调用的方法
 动态绑定将调用方法的确定也推迟到运行时。在编译时，方法的调用并不和代码绑定在一起，只有在消实发送出来之后，才确定被调用的代码。通过动态类型和动态绑定技术，您的代码每次执行都可以得到不同的结果。运行时因子负责确定消息的接 收者和被调用的方法。运行时的消息分发机制为动态绑定提供支持。当您向一个动态类型确定了的对象发送消息时，运行环境系统会通过接收者的 isa 指针定位对象的类，并以此为起点确定被调用的方法，方法和消息是动态绑定的。而且，您不必在 Objective-C 代码中做任何工作，就可以自动获取动态绑定的好处。
 
 */
@implementation JJiOSInterview05

@end
