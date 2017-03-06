//
//  VCManager.m
//  JJ_Class_14_ReactiveCocoa
//
//  Created by Jay on 2017/3/2.
//  Copyright © 2017年 JayJJ. All rights reserved.
//

#import "VCManager.h"

@implementation VCManager

+ (VCManager *)sharedManager {
    static VCManager *sharedDBManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDBManager = [[VCManager alloc] init];
    });
    return sharedDBManager;
}

- (void)testVC {
    UIViewController *visibleVC = self.vc.navigationController.visibleViewController;
    
    UIViewController *topVC = self.vc.navigationController.topViewController;
    
    UIViewController *vc = topVC;
    
    UIViewController *newVC = [[UIViewController alloc] init];
    newVC.view.backgroundColor = [UIColor whiteColor];
    
    [vc.navigationController pushViewController:newVC animated:YES];
    
}


- (void)visibleVC {
    
    
    
}



@end
