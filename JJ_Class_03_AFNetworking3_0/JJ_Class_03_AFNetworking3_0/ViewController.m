//
//  ViewController.m
//  JJ_Class_03_AFNetworking3_0
//
//  Created by Jay on 16/8/31.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking/AFNetworking/AFNetworking.h"

#define DOUBAN_BOOK @"https://api.douban.com/v2/book/1220562"

@interface ViewController () <NSURLSessionDownloadDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testAFHTTPSessionManagerGET];
}

#pragma mark - Private Methods

- (void)testNSURLSession {
    // 1. url
    NSURL *url = [NSURL URLWithString:@"http://example.com/resources/123.json"];
    
    // 2. session 苹果直接提供了一个全局的session
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3. 由session发起任务
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // 反序列化
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        NSLog(@"%@", result);
        
        
        // 更新UI在主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"更新UI");
        });
        
    }];
    
    // 4. 任务启动
    [sessionDataTask resume];
    
}

//下载 block
- (void)testDownloadTaskWithURLBlock {
    // 1. url
    NSURL *url = [NSURL URLWithString:@"http://example.com/resources/123.json"];
    
    // 2. session 苹果直接提供了一个全局的session
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3. 由session发起任务 下载
    NSURLSessionDownloadTask *sessionDownloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSLog(@"文件的路径%@", location.path);
        
        NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSLog(@"%@", cacheDir);
        
    }];
    
    // 4. 任务启动
    [sessionDownloadTask resume];
}

//下载 delegate
- (void)testDownloadTaskWithURLDelegate {
    // 1. url
    NSURL *url = [NSURL URLWithString:@"http://example.com/resources/123.json"];
    
    // 2. 实例化一个session对象
    // Configuration可以配置全局的网络访问的参数
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // 指定回调方法工作的线程
    //    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    // NSURLSession 如果不指定线程，默认就是子线程
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    // 发起
    NSURLSessionDownloadTask *sessionDownloadTask = [session downloadTaskWithURL:url];
    
    //继续任务
    [sessionDownloadTask resume];
    
}


- (void)testAFHTTPSessionManagerGET {
    NSURL *URL = [NSURL URLWithString:DOUBAN_BOOK];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"downloadProgress : %@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"task : %@ responseObject : %@", task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"task : %@ error : %@", task, error);
    }];
}

#pragma mark - NSURLSessionDownloadDelegate
// 1. 下载完成被调用的方法  iOS 7 & iOS 8都必须实现
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"下载完成..");
}

// 2. 下载进度变化的时候被调用的。
/**
 bytesWritten：     本次写入的字节数
 totalBytesWritten：已经写入的字节数（目前下载的字节数）
 totalBytesExpectedToWrite： 总的下载字节数(文件的总大小)
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"%f---%@", progress, [NSThread currentThread]);
}

// 3. 短点续传的时候，被调用的。一般什么都不用写
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}


@end
