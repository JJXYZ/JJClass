//
//  RWTViewModelServicesImpl.m
//  RWTFlickrSearch
//
//  Created by Jay on 15/12/1.
//  Copyright © 2015年 Colin Eberhardt. All rights reserved.
//

#import "RWTViewModelServicesImpl.h"
#import "RWTFlickrSearchImpl.h"
#import "RWTSearchResultsViewController.h"

@interface RWTViewModelServicesImpl ()

@property (strong, nonatomic) RWTFlickrSearchImpl *searchService;

@property (weak, nonatomic) UINavigationController *navigationController;

@end

@implementation RWTViewModelServicesImpl

#pragma mark - Lifecycle

- (instancetype)init
{
    if (self = [super init])
    {
        _searchService = [RWTFlickrSearchImpl new];
    }
    
    return self;
}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    if (self = [super init]) {
        _searchService = [RWTFlickrSearchImpl new];
        _navigationController = navigationController;
    }
    return self;
}

#pragma mark - RWTViewModelServices

- (id<RWTFlickrSearch>)getFlickrSearchService
{
    return self.searchService;
}

- (void)pushViewModel:(id)viewModel {
    id viewController;
    
    if ([viewModel isKindOfClass:RWTSearchResultsViewModel.class]) {
        viewController = [[RWTSearchResultsViewController alloc] initWithViewModel:viewModel];
    } else {
        NSLog(@"an unknown ViewModel was pushed!");
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}
/**
 *  上面的方法使用提供的ViewModel的类型来确定需要哪个视图。在上面的例子中，只有一个ViewModel-View对，不过我确信你可以看到如何扩展这个模式。导航控制器push了结果视图。
 */

@end
