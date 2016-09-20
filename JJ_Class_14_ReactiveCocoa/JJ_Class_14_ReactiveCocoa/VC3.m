//
//  VC3.m
//  JJ_Class_14_ReactiveCocoa
//
//  Created by Jay on 2016/9/18.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "VC3.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "VM3.h"

@interface VC3 ()

@property (nonatomic, strong, nonnull) VM3 *vm3;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchActivity;

@end

@implementation VC3

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchTextField_RAC];
    [self searchButton_RAC];
    [self searchActivity_RAC];
    [self resignFirstResponder_RAC];
    [self searchSubject_RAC];    
}

#pragma mark - Private Methods

#pragma mark - RAC
/**
    在ReactiveCocoa中，使用了分类将rac_textSignal属性添加到UITextField类中。它是一个信号，在文本域每次更新时会发送一个包含当前文本的next事件。
 
    RAC是一个用于做绑定操作的宏，上面的代码会使用rac_textSignal发出的next信号来更新viewModel的searchText属性。
 */
- (void)searchTextField_RAC {
    RAC(self.vm3, searchText) = [RACSignal merge:@[self.searchTextField.rac_textSignal, RACObserve(self.searchTextField, text)]];
}

/**
    rac_command属性是UIButton的ReactiveCocoa分类中添加的属性。上面的代码确保点击按钮执行给定的命令，且按钮的可点击状态反应了命令的可用状态。
 */
- (void)searchButton_RAC {
    self.searchButton.rac_command = self.vm3.executeSearchCommand;
}

/**
    RACCommand监听了搜索按钮状态的更新，但处理activity indicator的可见性则由我们负责。RACCommand暴露了一个executing属性，它是一个信号，发送true或false来标明命令开始和结束执行的时间。我们可以用这个来影响当前命令的状态。
 */
- (void)searchActivity_RAC {
    RAC([UIApplication sharedApplication], networkActivityIndicatorVisible) = self.vm3.executeSearchCommand.executing;
    
    //当命令执行时，应该隐藏加载indicator。这可以通过not操作来反转信号。
    RAC(self.searchActivity, hidden) = [self.vm3.executeSearchCommand.executing not];
    
    [self.vm3.executeSearchCommand.executing subscribeNext:^(NSNumber *x) {
        if (x.boolValue) {
            [self.searchActivity startAnimating];
        }
        else {
            [self.searchActivity stopAnimating];
        }
    }];
    
}

/**
    这段代码确保命令执行时隐藏键盘。executionSignals属性发送由命令每次执行时生成的信号。这个属性是信号的信号(见ReactiveCocoa Tutorial – The Definitive Introduction: Part 1/2)。当创建和发出一个新的命令执行信号时，隐藏键盘。
 */
- (void)resignFirstResponder_RAC {
    [self.vm3.executeSearchCommand.executionSignals subscribeNext:^(id x) {
        [self.searchTextField resignFirstResponder];
    }];
}

- (void)searchSubject_RAC {
    [self.vm3.searchSubject subscribeNext:^(id x) {
        NSLog(@"searchSubject_RAC");
        
        self.searchTextField.text = @"哈哈哈哈";
        
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"self.vm3.searchText = %@", self.vm3.searchText);
        });
    }];
}



#pragma mark - Property

- (VM3 *)vm3 {
    if (_vm3) {
        return _vm3;
    }
    _vm3 = [[VM3 alloc] init];
    return _vm3;
}
@end
