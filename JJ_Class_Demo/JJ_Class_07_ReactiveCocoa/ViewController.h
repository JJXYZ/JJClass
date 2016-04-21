//
//  ViewController.h
//  JJ_Class_07_ReactiveCocoa
//
//  Created by Jay on 15/11/26.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnRACSubject;
- (IBAction)clickRACSubject:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnRACReplaySubject;

@end

