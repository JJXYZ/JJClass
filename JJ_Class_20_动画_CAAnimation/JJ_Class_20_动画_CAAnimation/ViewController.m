//
//  ViewController.m
//  JJ_Class_20_动画_CAAnimation
//
//  Created by Jay on 2016/9/23.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "ViewController.h"
#import "VC1.h"
#import "VC2.h"
#import "VC3.h"
#import "VC4.h"

@interface ViewController () 



- (IBAction)clickVC1:(id)sender;
- (IBAction)clickVC2:(id)sender;
- (IBAction)clickVC3:(id)sender;
- (IBAction)clickVC4:(id)sender;
- (IBAction)clickVC5:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
}

#pragma mark - Event

- (IBAction)clickVC1:(id)sender {
    VC1 *vc1 = [[VC1 alloc] init];
    [self.navigationController pushViewController:vc1 animated:YES];
}

- (IBAction)clickVC2:(id)sender {
    VC2 *vc2 = [[VC2 alloc] init];
    [self.navigationController pushViewController:vc2 animated:YES];
}

- (IBAction)clickVC3:(id)sender {
    VC3 *vc3 = [[VC3 alloc] init];
    [self.navigationController pushViewController:vc3 animated:YES];
}

- (IBAction)clickVC4:(id)sender {
    VC4 *vc4 = [[VC4 alloc] init];
    [self.navigationController pushViewController:vc4 animated:YES];
}

- (IBAction)clickVC5:(id)sender {
}


@end
