//
//  searchModel.m
//  JJ_Class_14_ReactiveCocoa
//
//  Created by Jay on 2016/9/18.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "SearchImp.h"


typedef void (^RWSignInResponse)(BOOL success);

@interface SearchImp () 

@end

@implementation SearchImp

#pragma mark - Private Methods

- (void)signInComplete:(RWSignInResponse)completeBlock {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        completeBlock(YES);
    });
}

#pragma mark - SearchProtocol

- (RACSignal *)searchSignal:(NSString *)searchString {
    RACSignal *signInSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self signInComplete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"RACDisposable");
        }];
    }];
    return signInSignal;
}


@end
