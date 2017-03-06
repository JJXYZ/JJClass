//
//  VC5_1.m
//  JJ_Class_14_ReactiveCocoa
//
//  Created by Jay on 2017/2/27.
//  Copyright © 2017年 JayJJ. All rights reserved.
//

#import "VC5_1.h"
#import "VCManager.h"
@interface VC5_1 ()

@end

@implementation VC5_1

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%@ %@ viewWillAppear ", [self class], self.navigationController);
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    NSLog(@"%@ %@ viewWillDisappear ", [self class], self.navigationController);
}


- (IBAction)clickBackBtn:(id)sender {
    NSLog(@"%@ %@ clickBackBtn", self.navigationController, self.class);
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)clickBack:(id)sender {
    NSLog(@"%@ %@ clickBack", self.navigationController, self.class);
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickTestVC:(id)sender {
    [[VCManager sharedManager] testVC];
}

@end
