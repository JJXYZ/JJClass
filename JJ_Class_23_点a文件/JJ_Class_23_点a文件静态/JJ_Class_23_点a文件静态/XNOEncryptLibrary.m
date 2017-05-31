//
//  XNOEncryptLibrary.m
//  XNOnline
//
//  Created by Jay on 2017/5/1.
//  Copyright © 2017年 xiaoniu88. All rights reserved.
//

//Helper
#import "XNOEncryptLibrary.h"
#import "XNOJSONUtils.h"
#import "XNOEncryptAndDecrypt.h"
#import "NSString+AES.h"
#import "RSA.h"

/** XDUwLC6AZDpZpRbWARLcGA== */
signed char kWebTokenAESkey[32] = {
    92, 53, 48, 44, 46, -128, 100, 58, 89, -91,
    22, -42, 1, 18, -36, 24
};

static NSString * const kAutoTokenSalt = @"$G5hcHA";

static NSString * const kIDFAAESKey = @"IOS-APP-XNZX-128";

@implementation XNOEncryptLibrary

#pragma mark - Public Methods

+ (NSString *)encryptWebForParameters:(NSDictionary *)params {
    //转jsonData
    NSData *jsonData = [XNOJSONUtils toJSONData:params];
    
    //AES加密
    NSData *aesData = [XNOEncryptAndDecrypt AESEncrypt:jsonData forKey:[NSData dataWithBytes:kWebTokenAESkey length:sizeof(kWebTokenAESkey)]];
    //base64String编码
    NSString *base64String = [XNOEncryptAndDecrypt base64Encode:aesData];
    
    return base64String;
}

+ (NSData *)encryptAutoToken:(NSString *)autoToken {
    //(autoToken+Salt)使用RSA加密
    RSA *rsaEncode = [[RSA alloc] init];
    NSData *rasData = [rsaEncode encryptWithString:[autoToken stringByAppendingString:kAutoTokenSalt]];
    
    return rasData;
}

+ (NSString *)encryptIDFA:(NSString *)idfa {
    NSString *idfaEncode = [idfa encryptAESWithKey:kIDFAAESKey];
    NSLog(@"idfa: %@, %@", idfa, idfaEncode);
    //NSLog(@"decode:%@",[idfaEncode decryptAESWithKey:kIDFAAESKey]);
    
    return idfaEncode;
}

@end
