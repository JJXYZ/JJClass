//
//  RWTSearchResultsItemViewModel.h
//  RWTFlickrSearch
//
//  Created by Jay on 15/12/2.
//  Copyright © 2015年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTFlickrPhoto.h"
#import "RWTViewModelServices.h"

/**
 *  获取可见cell的元数据
 
 我们可以扩展当前代码来获取所有搜索结果的元数据。然而，如果我们有100条结果，则需要立即发起200个请求，每幅图片2个请求。大多数API都有些限制，这种调用方式会阻塞我们的请求调用，至少是临时的。
 
 在一个table中，我们只需要获取当前显示的单元格所对象的结果的元数据。所以，如何实现这个行为呢？当然，我们需要一个ViewModel来表示这些数据。当前RWTSearchResultsViewModel暴露了一个绑定到View的RWTFlickrPhoto实例的数组，它们的暴露给View的Model层对象。为了添加这种可见性，我们将给ViewModel中的model对象添加view-centric状态。
 
 在ViewModel分组中添加RWTSearchResultsItemViewModel类，打开头文件并各以下代码更新：
 */
@interface RWTSearchResultsItemViewModel : NSObject

/**
 *  看看初始化方法，这个ViewModel封装了一个RWTFlickrPhoto模型对象的实例。这个ViewModel包含以下几类属性：
 
 表示底层Model属性的属性(title, url)
 当获取到元数据时动态更新的属性(favorites, comments)
 isVisible，用于表示ViewModel是否可见
 */
- (instancetype) initWithPhoto:(RWTFlickrPhoto *)photo services:(id<RWTViewModelServices>)services;

@property (nonatomic) BOOL isVisible;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSNumber *favorites;
@property (strong, nonatomic) NSNumber *comments;

@end
