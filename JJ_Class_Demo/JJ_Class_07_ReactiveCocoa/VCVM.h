//
//  VCVM.h
//  JJ_Class_Demo
//
//  Created by Jay on 16/5/31.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "BaseVM.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface VCVM : BaseVM

@property (nonatomic, strong) RACSubject *subject;


- (void)createRACSubject;


- (RACSignal *)createSignal;

@end
