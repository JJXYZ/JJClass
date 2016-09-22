//
//  VC3.m
//  JJ_Class_21_绘图_drawRect
//
//  Created by Jay on 2016/9/20.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "VC3.h"
#import "View3.h"

@interface VC3 ()

@property (nonatomic, strong) View3 *view3;

@property (nonatomic, strong) UISlider *slider;


@end

@implementation VC3

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.view3];
    [self.view addSubview:self.slider];
}

#pragma mark - Event

- (void)sliderValueChanged:(UISlider *)slider {
    self.view3.fontSize = slider.value;
}

#pragma mark - Property

- (View3 *)view3 {
    if (_view3) {
        return _view3;
    }
    _view3 = [[View3 alloc] initWithFrame:CGRectMake(20, 100, 280, 100)];
    _view3.backgroundColor = [UIColor grayColor];
    _view3.userInteractionEnabled = YES;
    return _view3;
}

- (UISlider *)slider {
    if (_slider) {
        return _slider;
    }
    _slider = [[UISlider alloc]initWithFrame:CGRectMake(20, 300, 280, 20)];
    [_slider setMinimumValue:10.0];
    [_slider setMaximumValue:40.0];
    [_slider setValue:20.0];
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    return _slider;
}

@end
