//
//  ViewController.m
//  JJ_Class_24_DecimalUtils
//
//  Created by Jay on 2017/8/14.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "ViewController.h"
#import "JJDecimalUtils.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testDecimalUtils];
}

#pragma mark - Private Methods

- (void)testDecimalUtils {
    
//    [JJDecimalUtils roundDownWithString:@"1234.56" scale:2];
//    [JJDecimalUtils roundDownWithString:@"1234.569" scale:2];
//    [JJDecimalUtils roundDownWithString:@"1234.5678" scale:2];
//    
//    [JJDecimalUtils roundDownWithString:@"1234.567" scale:3];
//    [JJDecimalUtils roundDownWithString:@"1234.5678" scale:3];
    
    NSLog(@"roundDownWithString ------------------------------------------\n\n");
    
//    [JJDecimalUtils roundDownWithDouble:1234.00 scale:2];
//    [JJDecimalUtils roundDownWithDouble:1234.56 scale:2];
//    [JJDecimalUtils roundDownWithDouble:1234.569 scale:2];
//    [JJDecimalUtils roundDownWithDouble:1234.5678 scale:2];
//    
//    [JJDecimalUtils roundDownWithDouble:1234.567 scale:3];
//    [JJDecimalUtils roundDownWithDouble:1234.5678 scale:3];
    
    NSLog(@"roundDownWithDouble ------------------------------------------\n\n");
    
//    [JJDecimalUtils roundDown2Double:1234.56];
    
    NSLog(@"roundDown2Double------------------------------------------\n\n");
    
//    [JJDecimalUtils roundDown2FormatDouble:1234.56];
//    [JJDecimalUtils roundDown2FormatDouble:1234.567];
    
    NSLog(@"roundDown2FormatDouble------------------------------------------\n\n");
    
    [JJDecimalUtils roundDown2ZeroWithDouble:1234.50];
    [JJDecimalUtils roundDown2ZeroWithDouble:1234.5678];
    [JJDecimalUtils roundDown2ZeroWithDouble:1234.00];
    [JJDecimalUtils roundDown2ZeroWithDouble:1234];
    [JJDecimalUtils roundDown2ZeroWithDouble:1234.5499999];
    [JJDecimalUtils roundDown2ZeroWithDouble:1234.56];
    
    NSLog(@"roundDown2ZeroWithDouble------------------------------------------\n\n");
    
//    [JJDecimalUtils roundDown4ZeroWithDouble:1234.5678];
//    [JJDecimalUtils roundDown4ZeroWithDouble:1234.5699999999];
//    [JJDecimalUtils roundDown4ZeroWithDouble:1234.567];
//    [JJDecimalUtils roundDown4ZeroWithDouble:1234.56];
//    [JJDecimalUtils roundDown4ZeroWithDouble:1234.5];
//    [JJDecimalUtils roundDown4ZeroWithDouble:1234.00];
//    [JJDecimalUtils roundDown4ZeroWithDouble:1234];
    NSLog(@"roundDown4ZeroWithDouble------------------------------------------\n\n");
    
}

@end
