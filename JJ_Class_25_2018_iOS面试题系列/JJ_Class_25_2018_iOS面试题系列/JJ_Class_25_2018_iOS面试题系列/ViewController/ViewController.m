//
//  ViewController.m
//  JJ_Class_25_2018_iOS面试题系列
//
//  Created by Jay on 2018/4/16.
//  Copyright © 2018年 com.xiaoniu88.XNOnline. All rights reserved.
//

#import "ViewController.h"

void swap(int p1, int p2)
{
    int p;
    p = p1;
    p1 = p2;
    p2 = p;
}



@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    int a = 10;
    int b = 20;
    
    swap(a, b);
    
    
}

@end
