//
//  VC3.m
//  JJ_Class_20_动画_CAAnimation
//
//  Created by Jay on 2016/9/23.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "VC3.h"
#import "View3.h"

@interface VC3 ()

@property (nonatomic, strong) View3 *view3;

@property (strong, nonatomic) NSArray *imageArr;

@end

@implementation VC3

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.view3];
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchWithTouches:(NSSet *)touches {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self.view];
    
    
}


#pragma mark - Property

- (UIView *)view3 {
    if (_view3) {
        return _view3;
    }
    _view3 = [[View3 alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    _view3.backgroundColor = [UIColor purpleColor];
    return _view3;
}

- (NSArray *)imageArr {
    if (_imageArr) {
        return _imageArr;
    }
    _imageArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"image1"], [UIImage imageNamed:@"image2"], [UIImage imageNamed:@"image3"], nil];
    return _imageArr;
}

@end
