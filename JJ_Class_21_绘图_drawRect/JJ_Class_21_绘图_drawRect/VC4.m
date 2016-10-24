//
//  VC4.m
//  JJ_Class_21_绘图_drawRect
//
//  Created by Jay on 2016/9/20.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "VC4.h"
#import "View4.h"

@interface VC4 ()

@property (nonatomic, strong) View4 *View4;

@end

@implementation VC4

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.View4];
}

#pragma mark - Property

- (View4 *)View4 {
    if (_View4) {
        return _View4;
    }
    _View4 = [[View4 alloc] initWithFrame:CGRectMake(10, 100, 200, 200)];
    _View4.backgroundColor = [UIColor whiteColor];
    return _View4;
}

@end
