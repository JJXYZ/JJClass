//
//  VC2.m
//  JJ_Class_21_绘图_drawRect
//
//  Created by Jay on 2016/9/20.
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

#pragma mark - Property

- (View2 *)view2 {
    if (_view2) {
        return _view2;
    }
    _view2 = [[View2 alloc] initWithFrame:self.view.bounds];
    _view2.backgroundColor = [UIColor whiteColor];
    return _view2;
}

@end
