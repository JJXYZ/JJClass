//
//  Created by Colin Eberhardt on 23/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "RWTSearchResultsViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "CETableViewBindingHelper.h"
#import "RWTSearchResultsTableViewCell.h"

@interface RWTSearchResultsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *searchResultsTable;

@property (strong, nonatomic) RWTSearchResultsViewModel *viewModel;

@property (strong, nonatomic) CETableViewBindingHelper *bindingHelper;

@end

@implementation RWTSearchResultsViewController

#pragma mark - Lifecycle

- (instancetype)initWithViewModel:(RWTSearchResultsViewModel *)viewModel {
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#if 0
    [self.searchResultsTable registerClass:UITableViewCell.class
                    forCellReuseIdentifier:@"cell"];
    self.searchResultsTable.dataSource = self;
#endif
    
    [self bindViewModel];
}

#pragma mark - Private Methods

- (void)bindViewModel {
    self.title = self.viewModel.title;

    /**
     *  这从nib文件中创建了一个UINib实例并构建了一个绑定帮助类实例，sourceSignal是通过观察ViewModel的searchResults属性改变而创建的。
     */
    UINib *nib = [UINib nibWithNibName:@"RWTSearchResultsTableViewCell" bundle:nil];
    self.bindingHelper = [CETableViewBindingHelper bindingHelperForTableView:self.searchResultsTable sourceSignal:RACObserve(self.viewModel, searchResults) selectionCommand:nil templateCell:nib];
    self.bindingHelper.delegate = self;
}

#pragma mark - UIScrollViewDelegate
/**
 *  table view每次滚动时，调用这个方法。它迭代所有的可见cell，计算用于视差效果的偏移值。这个偏移值依赖于cell在table view中可见部分的位置
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSArray *cells = [self.searchResultsTable visibleCells];
    for (RWTSearchResultsTableViewCell *cell in cells) {
        CGFloat value = -40 + (cell.frame.origin.y - self.searchResultsTable.contentOffset.y) / 5;
        [cell setParallax:value];
    }
}

#if 0
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [self.viewModel.searchResults[indexPath.row] title];
    return cell;
}
#endif

@end
