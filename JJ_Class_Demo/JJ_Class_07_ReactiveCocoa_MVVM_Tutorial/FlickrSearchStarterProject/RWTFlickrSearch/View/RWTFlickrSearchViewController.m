//
//  Created by Colin Eberhardt on 13/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RWTFlickrSearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *searchHistoryTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (weak, nonatomic) RWTFlickrSearchViewModel *viewModel;

@end

@implementation RWTFlickrSearchViewController

#pragma mark - Lifecycle

- (instancetype)initWithViewModel:(RWTFlickrSearchViewModel *)viewModel
{
    self = [super init];
    
    if (self)
    {
        _viewModel = viewModel;
    }
    
    return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self bindViewModel];
  
}

#pragma mark - Private Methods

- (void)bindViewModel
{
    self.title = self.viewModel.title;
    /**
     *  在ReactiveCocoa中，使用了分类将rac_textSignal属性添加到UITextField类中。它是一个信号，在文本域每次更新时会发送一个包含当前文本的next事件。
     
     RAC是一个用于做绑定操作的宏，上面的代码会使用rac_textSignal发出的next信号来更新viewModel的searchText属性。
     */
    RAC(self.viewModel, searchText) = self.searchTextField.rac_textSignal;
    
    /**
     *  rac_command属性是UIButton的ReactiveCocoa分类中添加的属性。上面的代码确保点击按钮执行给定的命令，且按钮的可点击状态反应了命令的可用状态。
     
     可以看到，当输入有效点击按钮时，按钮会置灰2秒钟，当执行的信号完成时又可点击。我们可以看下控制台的输出，可以发现空信号会立即完成，而延迟操作会在2秒后发出事件：
     */
    self.searchButton.rac_command = self.viewModel.executeSearch;
    
    
    /**
     *  RACCommand监听了搜索按钮状态的更新，但处理activity indicator的可见性则由我们负责。RACCommand暴露了一个executing属性，它是一个信号，发送true或false来标明命令开始和结束执行的时间。我们可以用这个来影响当前命令的状态。
     */
    RAC([UIApplication sharedApplication], networkActivityIndicatorVisible) = self.viewModel.executeSearch.executing;
    
    /**
     *  当命令执行时，应该隐藏加载indicator。这可以通过not操作来反转信号。
     */
    RAC(self.loadingIndicator, hidden) = [self.viewModel.executeSearch.executing not];
    
    /**
     *  这段代码确保命令执行时隐藏键盘。executionSignals属性发送由命令每次执行时生成的信号。这个属性是信号的信号(见ReactiveCocoa Tutorial – The Definitive Introduction: Part ½)。当创建和发出一个新的命令执行信号时，隐藏键盘。
     */
    [self.viewModel.executeSearch.executionSignals subscribeNext:^(id x) {
        [self.searchTextField resignFirstResponder];
    }];
}

@end
