//
//  ViewController.m
//  JJ_Class_13_运行时_SelfSuper
//
//  Created by Jay on 2018/7/27.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "Son.h"
#import "Cat.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self catDogFun];
}

#pragma mark - Private Methods
/**
 clang -rewrite-objc Son.m

 */
- (void)sonFun {
    Son *son = [[Son alloc] init];
    [son selfSuperFun];
    /*
     
    objc_msgSendSuper({self, Father}, sel_registerName("class"))
     
     ->objc_msgSend(self, sel_registerName("class"))
     
     
    objc_msgSend(self, sel_registerName("class"))
     
    objc_msgSend(objc_getClass("Father"), sel_registerName("class"))
     
    objc_msgSendSuper({self, Father}, sel_registerName("run"));
     
    objc_msgSend(self, sel_registerName("run"));
     
     
     self 是类的隐藏参数，指向当前调用方法的这个类的实例。而 super 本质是一个编译器标示符，和 self 是指向的同一个消息接受者，当使用 self 调用方法时，会从当前类的方法列表中开始找，如果没有，就从父类中再找；而当使用 super 时，则从父类的方法列表中开始找。然后调用父类的这个方法调用[self class] 时，会转化成 objc_msgSend 函数id objc_msgSend(id self, SEL op, ...)。
     调用[super class] 时 ，会转化成objc_msgSendSuper函数id objc_msgSendSuper(struct objc_super *super, SEL op, ...)。
     第一个参数是objc_super 这样一个结构体，其定义如下
     
     struct objc_super {
     __unsafe_unretained id receiver;
     __unsafe_unretained Class super_class;
     };
     第一个成员是 receiver, 类似于上面的 objc_msgSend 函数第一个参数 self.
     第二个成员是记录当前类的父类是什么，告诉程序从父类中开始找方法，找到方法后，最后内部是使用 objc_msgSend(objc_super->receiver, @selector(class))去调用，此时已经和[self class]调用相同了，故上述输出结果仍然返回 Son objc Runtime 开源代码对- (Class)class 方法的实现
     */
    
}

- (void)sonClassFun {
    Son *son = [[Son alloc] init];
    [son sonClass];
}

- (void)fooFun {
    Son *son = [[Son alloc] init];
    [son sonFooFun];
}

- (void)catDogFun {
    [[Cat alloc] init];
}


@end
