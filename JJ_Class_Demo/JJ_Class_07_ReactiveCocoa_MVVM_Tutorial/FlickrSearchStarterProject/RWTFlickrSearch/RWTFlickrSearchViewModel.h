//
//  RWTFlickrSearchViewModel.h
//  RWTFlickrSearch
//
//  Created by Jay on 15/12/1.
//  Copyright © 2015年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RWTViewModelServices.h"

@interface RWTFlickrSearchViewModel : NSObject

/**
 *  searchText属性表示文本域中显示文本，title属性表示导航条上的标题。
 */
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSString *title;

/**
 *  添加搜索命令
 */
@property (strong, nonatomic) RACCommand *executeSearch;


- (instancetype)initWithServices:(id<RWTViewModelServices>)services;

@end
