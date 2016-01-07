//
//  ViewController.m
//  JJ_Class_10_Transforms
//
//  Created by Jay on 16/1/7.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *pView;

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 150)];
    self.pView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.pView];
    
    
    [self TransformScale];
}

#pragma mark - 仿射变换

- (void)TransformRotate {
    // 旋转
    //角度 angle  PI 3.14
    [UIView animateWithDuration:2 animations:^{
        CGAffineTransform transform = CGAffineTransformRotate(_pView.transform, M_PI_2);
        
        _pView.transform = transform;
    }];
}



/**
 *  CGAffineTransformMakeScale & CGAffineTransformScale
    http://www.jianshu.com/p/0ee900339103
 */

- (void)TransformScale {
    // 尺寸放大缩小
    //sx  横向的尺寸
    //sy  纵向的尺寸
#if 0
    [UIView animateWithDuration:2 animations:^{
        CGAffineTransform transform = CGAffineTransformScale(_pView.transform, 2, 2);
        
        _pView.transform = transform;
    }];
#endif
    
#if 0
    [UIView animateWithDuration:2 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(2, 2);
        _pView.transform = transform;
    } completion:^(BOOL finished) {
        
    }];
#endif
    
#if 1
    [UIView animateWithDuration:2 animations:^{
        _pView.frame = CGRectMake(150, 150, 200, 250);
    } completion:^(BOOL finished) {
        
    }];
#endif
}

- (void)TransformTranslate {
    //转移  平移
    // tx 横向  ty纵向
    
    /*
     CGAffineTransform transform = CGAffineTransformTranslate(view.transform, 50, 100);
     view.transform = transform;
     */
    /*
     [UIView animateWithDuration:3 animations:^{
     _view.transform = CGAffineTransformTranslate(_view.transform, 50, 100);
     }];
     */
}

@end
