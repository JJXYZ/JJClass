//
//  RWTViewModelServices.h
//  RWTFlickrSearch
//
//  Created by Jay on 15/12/1.
//  Copyright © 2015年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTFlickrSearch.h"

@protocol RWTViewModelServices <NSObject>

- (id<RWTFlickrSearch>)getFlickrSearchService;


/**
 *  答案已经在RWTViewModelServices协议中给出来了。它获取了一个Model层的引用，我们将使用这个协议来允许ViewModel来初始化导航。打开RWTViewModelServices.h并添加以下方法来协议中：
 */
- (void)pushViewModel:(id)viewModel;

@end
