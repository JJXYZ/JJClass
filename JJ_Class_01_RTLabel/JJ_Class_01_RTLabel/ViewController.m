//
//  ViewController.m
//  JJ_Class_01_RTLabel
//
//  Created by Jay on 16/8/25.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "ViewController.h"
#import "RTLabel.h"
#import "DemoTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)clickVC1 {
    DemoTableViewController *vc = [[DemoTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
