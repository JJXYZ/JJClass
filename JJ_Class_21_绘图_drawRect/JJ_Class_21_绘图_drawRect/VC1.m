//
//  VC1.m
//  JJ_Class_21_绘图_drawRect
//
//  Created by Jay on 2016/9/20.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "VC1.h"
#import "View1.h"

@interface VC1 ()

@property (nonatomic, strong) View1 *view1;

@end

@implementation VC1

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.view1];
}

#pragma mark - Property

- (View1 *)view1 {
    if (_view1) {
        return _view1;
    }
    _view1 = [[View1 alloc] initWithFrame:self.view.bounds];
    _view1.backgroundColor = [UIColor whiteColor];
    return _view1;
}
@end
