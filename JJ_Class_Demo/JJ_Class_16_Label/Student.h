//
//  Student.h
//  JJ_Class_Demo
//
//  Created by Jay on 16/8/17.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Student : NSObject

- (void)run;

@end

@interface Student (Category)

- (void)run;

- (NSString *)run2;

@end