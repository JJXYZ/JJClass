//
//  VCManager.h
//  JJ_Class_14_ReactiveCocoa
//
//  Created by Jay on 2017/3/2.
//  Copyright © 2017年 JayJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCManager : NSObject

+ (VCManager *)sharedManager;

- (void)testVC;

@property (nonatomic, strong, nullable) ViewController *vc;

@end

NS_ASSUME_NONNULL_END
