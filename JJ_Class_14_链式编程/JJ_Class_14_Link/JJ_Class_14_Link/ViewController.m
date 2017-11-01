//
//  ViewController.m
//  JJ_Class_14_Link
//
//  Created by Jay on 2017/9/15.
//  Copyright © 2017年 JJ. All rights reserved.
//

#import "ViewController.h"
#import "JJPerson.h"
#import "NSString+JJCalculate.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self personSleep];
}

#pragma mark - Private Methods

- (void)personSleep {
    
    NSString *str1 = @"1";
    NSString *str2 = @"3";
    NSString *result1 = str1.calculateAdd(str2);
    NSLog(@"result1 = %@", result1);
    
    NSString *result2 = str1.calculateSub(str2);
    NSLog(@"result2 = %@", result2);
    
    NSString *result3 = str1.calculateMul(str2);
    NSLog(@"result3 = %@", result3);
    
    NSString *result4 = str1.calculateDiv(str2);
    NSLog(@"result4 = %@", result4);
    
    NSString *str6 = @"1.123999999999";
    NSString *str7 = @"1.123999999999";
    
    BOOL isResult1 = str6.notEqual(str7);
    NSLog(@"isResult1 = %d", isResult1);
    
}



@end
