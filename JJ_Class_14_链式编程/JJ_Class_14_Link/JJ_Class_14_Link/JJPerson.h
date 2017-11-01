//
//  JJPerson.h
//  JJ_Class_14_Link
//
//  Created by Jay on 2017/9/15.
//  Copyright © 2017年 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JJPersonSleepBlock)(NSUInteger duration);

@interface JJPerson : NSObject

- (JJPersonSleepBlock)sleep;


@end
