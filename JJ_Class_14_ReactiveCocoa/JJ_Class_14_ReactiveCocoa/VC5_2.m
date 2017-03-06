//
//  VC5_2.m
//  JJ_Class_14_ReactiveCocoa
//
//  Created by Jay on 2017/3/2.
//  Copyright © 2017年 JayJJ. All rights reserved.
//

#import "VC5_2.h"
#import "VCManager.h"

@interface VC5_2 ()

@end

@implementation VC5_2

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (IBAction)clickTestVC:(id)sender {
    [[VCManager sharedManager] testVC];
}

- (IBAction)clickBackBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
