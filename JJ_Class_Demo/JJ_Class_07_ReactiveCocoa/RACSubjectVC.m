//
//  RACSubjectVC.m
//  JJ_Class_Demo
//
//  Created by Jay on 16/4/21.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "RACSubjectVC.h"


@interface RACSubjectVC ()

@end

@implementation RACSubjectVC


- (instancetype)init {
    self = [super init];
    if (self) {
        self.subject = [RACSubject subject];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)clickBtnRACSubject:(id)sender {
    // 通知ViewController做事情
    if (self.subject) {
        [self.subject sendNext:nil];
    }
}
@end
