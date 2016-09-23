//
//  VC2.m
//  JJ_Class_20_动画_CAAnimation
//
//  Created by Jay on 2016/9/23.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "VC2.h"
#import "View2.h"

@interface VC2 ()

@property (nonatomic, strong) View2 *view2;

@end

@implementation VC2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.view2];
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view2 shakeAnimation];
}

#pragma mark - Property

- (UIView *)view2 {
    if (_view2) {
        return _view2;
    }
    _view2 = [[View2 alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    _view2.backgroundColor = [UIColor purpleColor];
    return _view2;
}


@end
