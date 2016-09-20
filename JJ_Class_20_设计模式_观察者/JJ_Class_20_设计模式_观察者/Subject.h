//
//  Subject.h
//  JJ_Class_20_设计模式_观察者
//
//  Created by Jay on 2016/9/20.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Observer.h"
#import "DisplayElement.h"

@protocol Subject <NSObject>

@required

- (void)registerObserver:(id<Observer, DisplayElement>)observer;

- (void)removeObserver:(id<Observer, DisplayElement>)observer;

- (void)notifyObservers;

@end
