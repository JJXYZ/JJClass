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
    NSLog(@"view1 1 : %@", NSStringFromCGRect(self.view1.frame));
    [self.view addSubview:self.view1];
    NSLog(@"view1 2 : %@", NSStringFromCGRect(self.view1.frame));
}

#pragma mark - Property

- (View1 *)view1 {
    if (_view1) {
        return _view1;
    }
    _view1 = [[View1 alloc] initWithFrame:CGRectMake(10.3, 100.3, 200.3, 200.3)];
    _view1.backgroundColor = [UIColor whiteColor];
    return _view1;
}
@end
