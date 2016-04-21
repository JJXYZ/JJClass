//
//  ViewController.m
//  Animation_Demo
//
//  Created by Liu on 15/12/14.
//  Copyright © 2015年 AngryBear. All rights reserved.
//

#import "ViewController.h"


static CGFloat const kDurationValue = 0.3f;

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)buttonOnClicked:(UIButton *)sender {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:@"收起" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissButton) forControlEvents:UIControlEventTouchUpInside];
    [vc.view addSubview:button];
    
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];
    
    CGFloat height = self.view.bounds.size.height;
    vc.view.frame = self.view.frame;
    vc.view.transform = CGAffineTransformMakeTranslation(0, height);
    [self.view addSubview:vc.view];
    [UIView animateWithDuration:kDurationValue animations:^{
        vc.view.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismissButton
{
    UIViewController *vc = [self.childViewControllers firstObject];
    [UIView animateWithDuration:kDurationValue animations:^{
        CGFloat sx = self.button.bounds.size.width/vc.view.bounds.size.width;
        CGFloat sy = self.button.bounds.size.height/vc.view.bounds.size.height;
        vc.view.transform = CGAffineTransformMakeScale(sx, sy);
        vc.view.frame = self.button.frame;
    } completion:^(BOOL finished) {
        [vc.view removeFromSuperview];
        
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }];
}

- (IBAction)click:(id)sender {
}
@end
