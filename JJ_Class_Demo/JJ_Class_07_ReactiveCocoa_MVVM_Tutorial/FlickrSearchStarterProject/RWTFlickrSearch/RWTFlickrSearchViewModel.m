//
//  RWTFlickrSearchViewModel.m
//  RWTFlickrSearch
//
//  Created by Jay on 15/12/1.
//  Copyright © 2015年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchViewModel.h"
#import "RWTSearchResultsViewModel.h"

@interface RWTFlickrSearchViewModel ()

@property (nonatomic, weak) id<RWTViewModelServices> services;

@end

@implementation RWTFlickrSearchViewModel

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithServices:(id<RWTViewModelServices>)services
{
    self = [super init];
    
    if (self)
    {
        _services = services;
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    self.searchText = @"search text";
    /**
     *  搜索按钮应该只有在用户输入有效时才可点击。为了方便起见，我们以输入字符大于3时输入有效为准。
     上面的代码使用RACObserve宏来从ViewModel的searchText属性创建一个信号。map操作将文本转化为一个true或false值的流。
     
     最后，distinctUntilChanges确保信号只有在状态改变时才发出值。
     */
    RACSignal *validSearchSignal = [[RACObserve(self, searchText) map:^id(NSString *text) {
          return @(text.length > 3);
      }] distinctUntilChanged];
    
    [validSearchSignal subscribeNext:^(id x) {
        NSLog(@"search text is valid %@", x);
    }];
    
    
    /**
     RACCommand是ReactiveCocoa中用于表示UI操作的一个类。它包含一个代表了UI操作的结果的信号以及标识操作当前是否被执行的一个状态。
     这创建了一个在validSearchSignal发送true时可用的命令。另外，需要在下面实现executeSearchSignal方法，它提供了命令所执行的操作。
     */
    self.executeSearch = [[RACCommand alloc] initWithEnabled:validSearchSignal
                                                 signalBlock:^RACSignal *(id input) {
                                                     return [self executeSearchSignal];
                                                 }];
    
    /**
     *  executeSearch属性是一个ReactiveCococa框架的RACCommand对象。RACCommand类有一个errors属性，用于发送命令执行时产生的任何错误。
     */
    self.connectionErrors = self.executeSearch.errors;
}


/**
 *   理论上讲，是ViewModel层驱动程序，这一层中的逻辑决定了在View中显示什么，及何时进行导航。这个方法允许ViewModel层push一个ViewModel，该方式与UINavigationController方式类似。在更新协议实现前，我们将在ViewModel层先让这个机制工作。
 */
- (RACSignal *)executeSearchSignal {
    return [[[self.services getFlickrSearchService] flickrSearchSignal:self.searchText]
            doNext:^(id result) {
                RWTSearchResultsViewModel *resultsViewModel =
                [[RWTSearchResultsViewModel alloc] initWithSearchResults:result services:self.services];
                [self.services pushViewModel:resultsViewModel];
            }];
}
/**
 *  上面的代码添加一个addNext操作到搜索命令执行时创建的信号。doNext块创建一个新的ViewModel来显示搜索结果，然后通过ViewModel服务将它push进来。现在是时候更新协议的实现代码了。为了满足这个需求，代码需要一个导航控制器的引用。
 */

#if 0
- (RACSignal *)executeSearchSignal {
    return [[[self.services getFlickrSearchService] flickrSearchSignal:self.searchText] logAll];
}
#endif

#if 0
- (RACSignal *)executeSearchSignal
{
    return [[self.services getFlickrSearchService] flickrSearchSignal:self.searchText];
}
#endif

#if 0
- (RACSignal *)executeSearchSignal
{
    /**
     *  在这个方法中，我们执行一些业务逻辑操作，以作为命令执行的结果，并通过信号异步返回结果。
     
     到目前为止，上述代码只提供了一个简单的实现：空信号会立即完成。delay操作会将其所接收到的next或complete事件延迟两秒执行。
     */
    return [[[[RACSignal empty] logAll] delay:2.0] logAll];
}
#endif




@end
