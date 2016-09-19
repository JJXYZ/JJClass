//
//  ViewController.m
//  JJ_Class_14_ReactiveCocoa
//
//  Created by Jay on 2016/9/16.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "ViewController.h"
#import "VC1.h"
#import "VC2.h"
#import "VC3.h"
#import "VC4.h"

/**
 *  ReactiveCocoa的核心是信号，它是一个事件流。使用ReactiveCocoa时，对于同一个问题，可能会有多种不同的方法来解决。ReactiveCocoa的目的就是为了简化我们的代码并更容易理解。如果使用一个清晰的管道，我们可以很容易理解问题的处理过程。在下一部分，我们将会讨论错误事件的处理及完成事件的处理。
 */

@interface ViewController ()

- (IBAction)clickVC1:(id)sender;
- (IBAction)clickVC2:(id)sender;
- (IBAction)clickVC3:(id)sender;
- (IBAction)clickVC4:(id)sender;
- (IBAction)clickVC5:(id)sender;

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Event

- (IBAction)clickVC1:(id)sender {
    VC1 *vc1 = [[VC1 alloc] init];
    [self.navigationController pushViewController:vc1 animated:YES];
}

- (IBAction)clickVC2:(id)sender {
    VC2 *vc2 = [[VC2 alloc] init];
    [self.navigationController pushViewController:vc2 animated:YES];
}

- (IBAction)clickVC3:(id)sender {
    VC3 *vc3 = [[VC3 alloc] init];
    [self.navigationController pushViewController:vc3 animated:YES];
}

- (IBAction)clickVC4:(id)sender {
    VC4 *vc4 = [[VC4 alloc] init];
    [self.navigationController pushViewController:vc4 animated:YES];
}

- (IBAction)clickVC5:(id)sender {
}
@end
