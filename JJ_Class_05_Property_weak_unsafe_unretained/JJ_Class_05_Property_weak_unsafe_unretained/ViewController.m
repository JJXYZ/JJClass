//
//  ViewController.m
//  JJ_Class_05_Property_weak_unsafe_unretained
//
//  Created by Jay on 16/8/31.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSString *string1;

@property (nonatomic, unsafe_unretained) NSString *string2;

@property (nonatomic, weak) NSString *string3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.string1 = [[NSString alloc] initWithUTF8String:"hello"];
    self.string2 = self.string1;
    self.string3 = self.string1;
    self.string1 = nil;
    
    [self performSelector:@selector(logString) withObject:nil afterDelay:10];
    
}

- (void)logString {
    NSLog(@"String 1 = %@", self.string1);
    
    NSLog(@"String 2 = %@", self.string2);
    
    NSLog(@"String 3 = %@", self.string3);
}

@end
