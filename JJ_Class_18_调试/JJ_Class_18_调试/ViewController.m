//
//  ViewController.m
//  JJ_Class_18_调试
//
//  Created by Jay on 2016/9/27.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, assign) NSUInteger type;

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *string = [self.array firstObject];
    NSLog(@"%@", string);
}

#pragma mark - Property

- (NSArray *)array {
    if (_array) {
        return _array;
    }
    _array = [NSArray arrayWithObjects:@"hello", @"world", nil];
    return _array;
}

@end
