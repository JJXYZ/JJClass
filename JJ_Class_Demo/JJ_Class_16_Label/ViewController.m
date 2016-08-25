//
//  ViewController.m
//  JJ_Class_16_Label
//
//  Created by Jay on 16/5/24.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "ViewController.h"
#import "RTLabel.h"
#import "DemoTableViewController.h"
#import "Student1.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Student1 *s = [[Student1 alloc] init];
    NSString *string = [s run2];
    NSLog(@"%@", string);
}

- (IBAction)clickVC1 {
    DemoTableViewController *vc = [[DemoTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
