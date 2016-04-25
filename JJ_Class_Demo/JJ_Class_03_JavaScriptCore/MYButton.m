//
//  MYButton.m
//  JJ_Class_Demo
//
//  Created by Jay on 16/4/22.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "MYButton.h"




@implementation MYButton


- (void)setOnClickHandler:(JSValue *)handler
{
#if 0
    /**
     *  根据官方文档关于JS－OC内存管理总结：由于JS中全部都是强引用，如果JS 与 OC互相引用时，就要防止OC也强引用JS，这样会形成引用循环，所以OC要想办法弱引用，但弱引用会被系统释放，所以把可能被释放的对象放到一个容器中来防止对象被被错误释放。
     */
    _jsValue = handler; // Retain cycle
    
    NSLog(@"%@", [_jsValue toString]);
#else
    /**
     *  如果直接保存 handler，就会出现内存泄露，因为 JS 中引用 button 对象是强引用，如果 Button 也用强引用来保存 JS 中的 handler，这就导致了 循环引用。我们没法改变 JavaScript 中的强引用机制，只能在 Objective-C 中弱引用 handler，为了防止 onclick handler 被错误释放， JavaScriptCore 给出的解决方案如下：
     */
    _onClickHandler1 = [JSManagedValue managedValueWithValue:handler];
    [_context.virtualMachine addManagedReference:_onClickHandler1 withOwner:self];
    
    NSLog(@"%@", [_onClickHandler1.value toString]);
    
#endif
    
}


- (void)dealloc {
    NSLog(@"MYButton dealloc");
}

@end
