//
//  ViewController.m
//  JJ_Class_02_SDWebImage375
//
//  Created by Jay on 16/8/25.
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
    
}

@end
