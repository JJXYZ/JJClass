//
//  RWTSearchResultsViewModel.m
//  RWTFlickrSearch
//
//  Created by Jay on 15/12/1.
//  Copyright © 2015年 Colin Eberhardt. All rights reserved.
//

#import "RWTSearchResultsViewModel.h"
#import "RWTFlickrPhoto.h"
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RWTSearchResultsItemViewModel.h"

@implementation RWTSearchResultsViewModel


- (instancetype)initWithSearchResults:(RWTFlickrSearchResults *)results services:(id<RWTViewModelServices>)services {
    if (self = [super init]) {
        _title = results.searchString;
#if 0
        _searchResults = results.photos;
#endif
        /**
         *  这只是简单地使用一个ViewModel来包装每一个Model对象。
         */
        _searchResults = [results.photos linq_select:^id(RWTFlickrPhoto *photo) {
            return [[RWTSearchResultsItemViewModel alloc] initWithPhoto:photo services:services];
        }];
        
        /**
         *  这段代码测试了新添加的方法，该方法从返回的结果中的第一幅图片获取图片元数据。运行程序后，会在控制台输出以下信息：
         */
        RWTFlickrPhoto *photo = results.photos.firstObject;
        RACSignal *metaDataSignal = [[services getFlickrSearchService] flickrImageMetadata:photo.identifier];
        [metaDataSignal subscribeNext:^(id x) {
            NSLog(@"%@", x);
        }];
    }
    return self;
}


@end
