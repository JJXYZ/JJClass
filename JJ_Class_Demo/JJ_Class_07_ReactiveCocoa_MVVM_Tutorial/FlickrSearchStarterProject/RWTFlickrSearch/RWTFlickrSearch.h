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

@end
