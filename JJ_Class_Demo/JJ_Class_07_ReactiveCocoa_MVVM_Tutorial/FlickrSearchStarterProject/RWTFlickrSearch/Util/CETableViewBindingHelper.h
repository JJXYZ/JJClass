//
//  RWTableViewBindingHelper.h
//  RWTwitterSearch
//
//  Created by Colin Eberhardt on 24/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

@import Foundation;
#import <ReactiveCocoa/ReactiveCocoa.h>

/// A helper class for binding view models with NSArray properties to a UITableView.
@interface CETableViewBindingHelper : NSObject

// forwards the UITableViewDelegate methods
@property (weak, nonatomic) id<UITableViewDelegate> delegate;

- (instancetype) initWithTableView:(UITableView *)tableView
                      sourceSignal:(RACSignal *)source
                  selectionCommand:(RACCommand *)selection
                      templateCell:(UINib *)templateCellNib;


/**
 *  table view绑定的缺失会很快导致视图控制器代码的增加。而手动绑定看上去又不太优雅。从概念上讲，在ViewModel的searchResults数组中的每一项是一个ViewMode，每个cell是对应一个ViewModel实例。在这篇博客中我创建了一个绑定帮助类CETableViewBindingHelper，允许我们定义用于子ViewModel的View，帮助类负责实现数据源协议。我们可以在当前工程的Util分组中找到这个帮助类。
 */
+ (instancetype) bindingHelperForTableView:(UITableView *)tableView
                              sourceSignal:(RACSignal *)source
                          selectionCommand:(RACCommand *)selection
                              templateCell:(UINib *)templateCellNib;

@end
