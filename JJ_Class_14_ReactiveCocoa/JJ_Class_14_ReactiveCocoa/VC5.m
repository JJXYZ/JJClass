//
//  VC5.m
//  JJ_Class_14_ReactiveCocoa
//
//  Created by Jay on 2017/2/27.
//  Copyright © 2017年 JayJJ. All rights reserved.
//

#import "VC5.h"
#import "VC5_1.h"
#import "VC5_2.h"

@interface VC5 ()

@end

@implementation VC5

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)clickPresentBt:(id)sender {
    VC5_2 *vc5_2 = [[VC5_2 alloc] init];
    NSLog(@"%@ %@", self.navigationController, self.class);
    [self presentViewController:vc5_2 animated:YES completion:^{
        
    }];
}

- (IBAction)clickNextBtn:(id)sender {
    VC5_1 *vc5_1 = [[VC5_1 alloc] init];
    NSLog(@"%@ %@", self.navigationController, self.class);
    [self.navigationController pushViewController:vc5_1 animated:YES];
}


@end
