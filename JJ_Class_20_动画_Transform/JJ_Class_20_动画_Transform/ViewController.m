//
//  ViewController.m
//  JJ_Class_20_动画_Transform
//
//  Created by Jay on 2016/9/20.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *pView;

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.pView];
    
    [self TransformTranslate];
}


#pragma mark - 仿射变换
// 旋转
- (void)TransformRotate {
    //角度 angle  PI 3.14
    [UIView animateWithDuration:2 animations:^{
        CGAffineTransform transform = CGAffineTransformRotate(self.pView.transform, M_PI_2);
        self.pView.transform = transform;
    }];
}

// 尺寸放大缩小
- (void)TransformScale {
    //sx  横向的尺寸
    //sy  纵向的尺寸
    [UIView animateWithDuration:2 animations:^{
        CGAffineTransform transform = CGAffineTransformScale(self.pView.transform, 2, 2);
        self.pView.transform = transform;
    }];
}

/**
 *  CGAffineTransformMakeScale & CGAffineTransformScale
 http://www.jianshu.com/p/0ee900339103
 */

- (void)TransformScale_Make {
    [UIView animateWithDuration:2 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(2, 2);
        self.pView.transform = transform;
    } completion:^(BOOL finished) {
        
    }];
}

//转移  平移
- (void)TransformTranslate {
    // tx 横向  ty纵向
     CGAffineTransform transform = CGAffineTransformTranslate(self.pView.transform, 0, 100);
    
     [UIView animateWithDuration:3 animations:^{
         self.pView.transform = transform;
     }];

}


#pragma mark - Property

- (UIView *)pView {
    if (_pView) {
        return _pView;
    }
    _pView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 150)];
    _pView.backgroundColor = [UIColor purpleColor];
    return _pView;
}
@end
