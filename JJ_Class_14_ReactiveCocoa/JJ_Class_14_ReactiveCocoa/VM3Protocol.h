//
//  VM3Protocol.h
//  JJ_Class_14_ReactiveCocoa
//
//  Created by Jay on 2016/9/18.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchProtocol.h"

@protocol VM3Protocol <NSObject>

- (id<SearchProtocol>)getSearchProtocol;

@end
