//
//  SearchProtocol.h
//  JJ_Class_14_ReactiveCocoa
//
//  Created by Jay on 2016/9/18.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol SearchProtocol <NSObject>

- (RACSignal *)searchSignal:(NSString *)searchString;

@end
