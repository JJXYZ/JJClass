//
//  MV3.h
//  JJ_Class_14_ReactiveCocoa
//
//  Created by Jay on 2016/9/18.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "VM3Protocol.h"

@interface VM3 : NSObject

@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSString *title;

@property (strong, nonatomic) RACCommand *executeSearchCommand;

@property (nonatomic, strong) RACSubject *searchSubject;

/** TODO: */
- (instancetype)initWithVM3Imp:(id<VM3Protocol>)vm3Imp;

@end
