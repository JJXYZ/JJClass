//
//  VM3Imp.m
//  JJ_Class_14_ReactiveCocoa
//
//  Created by Jay on 2016/9/18.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "VM3Imp.h"
#import "SearchImp.h"

@interface VM3Imp ()

@property (strong, nonatomic) SearchImp *searchImp;

@end

@implementation VM3Imp

- (instancetype)init {
    if (self = [super init]) {
        _searchImp = [SearchImp new];
    }
    return self;
}

#pragma mark - VM3Protocol

- (id<SearchProtocol>)getSearchProtocol {
    return self.searchImp;
}


@end
