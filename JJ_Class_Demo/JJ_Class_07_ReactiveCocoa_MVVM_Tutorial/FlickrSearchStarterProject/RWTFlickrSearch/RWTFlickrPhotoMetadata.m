//
//  RWTFlickrPhotoMetadata.m
//  RWTFlickrSearch
//
//  Created by Jay on 15/12/2.
//  Copyright © 2015年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrPhotoMetadata.h"

@implementation RWTFlickrPhotoMetadata

- (NSString *)description {
    return [NSString stringWithFormat:@"metadata: comments=%lU, faves=%lU",
            self.comments, self.favorites];
}

@end
