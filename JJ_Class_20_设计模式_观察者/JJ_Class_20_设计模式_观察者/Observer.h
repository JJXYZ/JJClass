//
//  Observer.h
//  JJ_Class_20_设计模式_观察者
//
//  Created by Jay on 2016/9/20.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Observer <NSObject>

@required

- (void)updateTemp:(float)temp humidity:(float)humidity pressure:(float)pressure;

@end
