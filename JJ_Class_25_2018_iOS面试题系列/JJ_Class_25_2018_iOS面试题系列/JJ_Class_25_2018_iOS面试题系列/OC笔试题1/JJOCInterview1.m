//
//  JJOCInterview1.m
//  JJ_Class_25_2018_iOS面试题系列
//
//  Created by Jay on 2018/4/19.
//  Copyright © 2018年 com.xiaoniu88.XNOnline. All rights reserved.
//

#import "JJOCInterview1.h"


/**
 1. #import 跟 #include、@class有什么区别？＃import<> 跟 #import""又什么区别？
 1> #import和#include都能完整地包含某个文件的内容，#import能防止同一个文件被包含多次
 2> @class仅仅是声明一个类名，并不会包含类的完整声明;@class还能解决循环包含的问题
 3> #import <> 用来包含系统自带的文件，#import “”用来包含自定义的文件
 
 2. 属性readwrite，readonly，assign，retain，copy，nonatomic 各是什么作用，在那种情况下用？
 1> readwrite：同时生成get方法和set方法的声明和实现
 2> readonly：只生成get方法的声明和实现
 3> assign：set方法的实现是直接赋值，用于基本数据类型
 4> retain：set方法的实现是release旧值，retain新值，用于OC对象类型
 5> copy：set方法的实现是release旧值，copy新值，用于NSString、block等类型
 6> nonatomic：非原子性，set方法的实现不加锁，不安全，性能高（atomic性能低，atomic通过锁定机制来确保其原子性,但只是读/写安全,不能绝对保证线程的安全，当多线程同时访问的时候，会造成线程不安全。可以使用线程锁来保证线程的安全。）
 
 3. 写一个setter方法用于完成@property （nonatomic,retain）NSString *name,写一个setter方法用于完成@property（nonatomic，copy）NSString *name.
 1>  @property (nonatomic, retain) NSString *name;
 - (void)setName:(NSString *)name
 {
 if (_name != name) {
 [_name release];
 _name = [name retain];
 }
 }
 
 2>  @property(nonatomic, copy) NSString *name;
 - (void)setName:(NSString *)name
 {
 if (_name != name) {
 [_name release];
 _name = [name copy];
 }
 }
 4. 对于语句NSString*obj = [[NSData alloc] init]; ，编译时和运行时obj分别是什么类型？
 1> 编译时是NSString类型
 2> 运行时是NSData类型
 
 5. 常见的object-c的数据类型有那些， 和C的基本数据类型有什么区别？
 1> 常用OC类型：NSString、NSArray、NSDictionary、NSData、NSNumber等
 2> OC对象需要手动管理内存，C的基本数据类型不需要管理内存
 
 6. id 声明的变量有什么特性？
 id声明的变量能指向任何OC对象
 
 7. Objective-C如何对内存管理的,说说你的看法和解决方法?
 1> 每个对象都有一个引用计数器，每个新对象的计数器是1，当对象的计数器减为0时，就会被销毁
 2> 通过retain可以让对象的计数器+1、release可以让对象的计数器-1
 3> 还可以通过autorelease pool管理内存
 4> 如果用ARC，编译器会自动生成管理内存的代码
 注意：不管是MRC还是ARC都是在编译时完成的
 
 8. 内存管理的几条原则时什么？按照默认法则.哪些方法生成的对象需要手动释放？在和property结合的时候怎样有效的避免内存泄露？
 1> 只要调用了alloc、copy、new方法产生了一个新对象，都必须在最后调用一次release或者autorelease
 2> 只要调用了retain，都必须在最后调用一次release或者autorelease
 3> @property如果用了copy或者retian，就需要对不再使用的属性做一次release操作
 4> 如果用了ARC，另外讨论
 
 9. 看下面的程序,三次NSLog会输出什么？为什么？
 NSMutableArray* ary = [[NSMutableArray array] retain];
 NSString *str = [NSString stringWithFormat:@"test"];
 [str retain];
 [ary addObject:str];
 NSLog(@"%ld", (unsigned long)[str retainCount]);
 [str retain];
 [str release];
 [str release];
 NSLog(@"%ld", (unsigned long)[str retainCount]);
 [ary removeAllObjects];
 NSLog(@"%ld", (unsigned long)[str retainCount]);
 结果：-1、-1、-1 。-1代表没有引用计数或者引用计数非常大，因为str是字符串，字符串在常量区，没有引用计数。引用计数为－1，这可以理解为NSString实际上是一个字符串常量，是没有引用计数的（或者它的引用计数是一个很大的值（使用%lu可以打印查看），对它做引用计数操作没实质上的影响）
 
 10. OC中创建线程的方法是什么？如果指定在主线程中执行代码？如何延时执行代码？
 1>  创建线程的方法
 NSThread
 NSOperationQueue和NSOperation
 GCD
 2>  主线程中执行代码
 [self performSelectorOnMainThread: withObject: waitUntilDone:];
 [self performSelector: onThread:[NSThread mainThread] withObject: waitUntilDone:];
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 3>  延时执行
 double delayInSeconds = 2.0;
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,
 (int64_t)(delayInSeconds * NSEC_PER_SEC));
 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
 });
 [self performSelector: withObject: afterDelay:];
 [NSTimer scheduledTimerWithTimeInterval: target: selector: userInfo: repeats:];
 
 */
@implementation JJOCInterview1

@end
