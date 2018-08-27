//
//  Son.m
//  JJ_Class_13_运行时_SelfSuper
//
//  Created by Jay on 2018/7/27.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "Son.h"

@interface NSObject (Foo)
+ (void)fooFun;
@end

@implementation NSObject (Foo)
- (void)fooFun {
    NSLog(@"IMP: -[NSObject(Foo) fooFun]");
}
@end


@implementation Son

#pragma mark - Initialize Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)run {
    NSLog(@"Son run");
}


- (void)selfSuperFun {
    NSLog(@"%@ Class", NSStringFromClass([Father class]));
    NSLog(@"%@ Class", NSStringFromClass([Son class]));
    
    NSLog(@"%@ Class", NSStringFromClass([super class]));
    NSLog(@"%@ Class", NSStringFromClass([self class]));
    
    [super run];
    [self run];
}

- (void)sonClass {
    BOOL res1 = [[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [[NSObject class] isMemberOfClass:[NSObject class]];
    
    BOOL res3 = [[Son class] isKindOfClass:[Son class]];
    BOOL res4 = [[Son class] isMemberOfClass:[Son class]];
    
    NSLog(@"%d %d %d %d", res1, res2, res3, res4);
}

- (void)sonFooFun {
    [NSObject fooFun];
    [[[NSObject alloc] init] fooFun];
    
    /**
     
     objc_msgSend(objc_getClass("NSObject"), sel_registerName("fooFun"));
     
     objc_msgSend(objc_msgSend(objc_msgSend(objc_getClass("NSObject"), sel_registerName("alloc")), sel_registerName("init")), sel_registerName("fooFun"));
     
     */
}


@end
