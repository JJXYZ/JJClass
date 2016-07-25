//
//  ViewController.m
//  JJ_Class_08_AFNetworking2.0
//
//  Created by Jay on 16/7/19.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking/AFNetworking/AFNetworking.h"

#define DOUBAN_BOOK @"https://api.douban.com/v2/book/1220562"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:DOUBAN_BOOK parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"operation : %@ responseObject : %@", operation, responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"operation : %@ error : %@", operation, error);
    }];
}

@end
