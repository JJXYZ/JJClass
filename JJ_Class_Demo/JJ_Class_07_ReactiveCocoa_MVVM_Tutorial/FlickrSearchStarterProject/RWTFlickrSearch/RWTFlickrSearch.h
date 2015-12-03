//
//  RWTFlickrSearch.h
//  RWTFlickrSearch
//
//  Created by Jay on 15/12/1.
//  Copyright © 2015年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


@protocol RWTFlickrSearch <NSObject>

- (RACSignal *)flickrSearchSignal:(NSString *)searchString;

/**
 *  ViewModel将使用这个方法来请求给定图片的元数据，如评论和收藏。
 */
- (RACSignal *)flickrImageMetadata:(NSString *)photoId;

@end
