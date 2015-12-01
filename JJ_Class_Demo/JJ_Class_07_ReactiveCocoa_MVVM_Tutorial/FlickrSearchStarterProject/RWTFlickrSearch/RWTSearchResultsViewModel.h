//
//  RWTSearchResultsViewModel.h
//  RWTFlickrSearch
//
//  Created by Jay on 15/12/1.
//  Copyright © 2015年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTViewModelServices.h"
#import "RWTFlickrSearchResults.h"

/**
 实现ViewModel导航
 
 当一个Flickr成功返回需要的结果时，程序导航到一个新的视图控制器来显示搜索结果。当前的程序只有一个ViewModel，即RWTFlickrSearchViewModel类。为了实现需要的功能，我们将添加一个新的ViewModel来返回到搜索结果视图。添加新的继承自NSObject的RWTSearchResultsViewModel类到ViewModel分组中，并更新其头文件：
 */

@interface RWTSearchResultsViewModel : NSObject 

- (instancetype)initWithSearchResults:(RWTFlickrSearchResults *)results services:(id<RWTViewModelServices>)services;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *searchResults;


@end
