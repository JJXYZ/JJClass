//
//  ViewController.m
//  JJ_Class_07_JS_TS_JavaScriptContext
//
//  Created by Jay on 16/8/31.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "ViewController.h"
#import "VC1.h"
#import "VC2.h"

@interface ViewController ()

- (IBAction)clickVC1:(id)sender;
- (IBAction)clickVC2:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)clickVC1:(id)sender {
    VC1 *vc = [[VC1 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickVC2:(id)sender {
    VC2 *vc = [[VC2 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
