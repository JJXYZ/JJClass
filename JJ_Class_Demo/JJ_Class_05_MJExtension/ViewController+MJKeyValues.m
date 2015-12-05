//
//  ViewController+MJKeyValues.m
//  JJ_Class_Demo
//
//  Created by Jay on 15/12/4.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "ViewController+MJKeyValues.h"
#import "MJExtension.h"

@implementation ViewController (MJKeyValues)


- (void)loadProperty {
    NSDictionary *dic = [self mj_keyValues];
    NSLog(@"self = %@", dic);
}


@end
