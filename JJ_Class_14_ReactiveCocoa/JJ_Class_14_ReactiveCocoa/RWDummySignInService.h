//
//  RWDummySignInService.h
//  RWReactivePlayground
//
//  Created by Colin Eberhardt on 18/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RWSignInResponse)(BOOL);

@interface RWDummySignInService : NSObject

/**
 *  这个方法带有一个用户名、密码和一个完成block。block会在登录成功或失败时调用。我们可以在subscribeNext:块中直接调用这个方法，但为什么不呢？因为这是一个异步操作，小心了。
 */
- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(RWSignInResponse)completeBlock;

@end
