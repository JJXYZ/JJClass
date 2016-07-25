//
//  ViewController.m
//  JJ_Class_08_SDWebImage
//
//  Created by Jay on 16/7/18.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  SDWebImage是iOS开发者经常使用的一个开源框架,这个框架的主要作用是：一个异步下载图片并且支持缓存的UIImageView分类。
     */
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://pic50.nipic.com/file/20140927/14386371_064014515000_2.jpg"] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"%@ %@ %@ %ld", image, error, imageURL, (long)cacheType);
    }];
    
    NSString *s = [ViewController getUidValidateExtendParams];
    NSLog(@"%@", s);
}

+ (NSString *)getUidValidateExtendParams {
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    NSString *uid = @"123456";
    NSString *validate = @"888888";
    
    [paramsDic setObject:uid forKey:@"uid"];
    [paramsDic setObject:validate forKey:@"validate"];
    
    NSString *apiResponseJson = [self toJSONString:paramsDic];
    
    return apiResponseJson;
}

+ (NSData *)toJSONStringData:(id)theData
{
    if (![NSJSONSerialization isValidJSONObject:theData]) {
        return nil;
    }
    
    NSError* error = nil;
    NSData *jsonStrData = [NSJSONSerialization dataWithJSONObject:theData options:kNilOptions error:&error];
    if (error != nil) {
        return nil;
    }
    return jsonStrData;
}

+ (NSString *)toJSONString:(id)theData {
    NSData *jsonStrData = [self toJSONStringData:theData];
    
    NSString *jsonStr = nil;
    if (jsonStrData) {
        jsonStr = [[NSString alloc] initWithData:jsonStrData encoding:NSUTF8StringEncoding];
    }
    else {
        jsonStr = nil;
    }
    
    return jsonStr;
}

@end
