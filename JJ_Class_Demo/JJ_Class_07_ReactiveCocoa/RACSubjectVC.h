//
//  RACSubjectVC.h
//  JJ_Class_Demo
//
//  Created by Jay on 16/4/21.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RACSubjectVC : UIViewController

@property (nonatomic, strong) RACSubject *subject;

- (IBAction)clickBtnRACSubject:(id)sender;

@end
