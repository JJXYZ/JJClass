//
//  ViewController.m
//  JJ_Class_13_运行时_YYModel
//
//  Created by Jay on 2017/1/9.
//  Copyright © 2017年 JJ. All rights reserved.
//

#import "ViewController.h"
#import "YYGHUser.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self handleUserJson];
}

#pragma mark - Private Methods

- (void)handleUserJson {
    NSDictionary *json = [self getUserJson];
    YYGHUser *user = [YYGHUser yy_modelWithJSON:json];
    
    NSLog(@"%@", user.description);
    
    NSObject *model = [user yy_modelToJSONObject];
    
    NSLog(@"%@", model);
    
    NSObject *modelString = [user yy_modelToJSONString];
    
    NSLog(@"%@", modelString);
}

- (NSDictionary *)getUserJson {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return json;
}

- (NSDictionary *)getWeiboJson {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"weibo" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return json;
}



@end
