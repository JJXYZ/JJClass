//
//  XNOEncryptLibrary.h
//  XNOnline
//
//  Created by Jay on 2017/5/1.
//  Copyright © 2017年 xiaoniu88. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XNOEncryptLibrary : NSObject

//根据参数生成Web请求串
+ (NSString *)encryptWebForParameters:(NSDictionary *)params;

//加密autoToken参数
+ (NSData *)encryptAutoToken:(NSString *)autoToken;

//加密idfa
+ (NSString *)encryptIDFA:(NSString *)idfa;

@end

NS_ASSUME_NONNULL_END
