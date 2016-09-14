//
//  ViewController.m
//  JJ_Class_13_运行时_MJExtension
//
//  Created by Jay on 2016/9/9.
//  Copyright © 2016年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "MJExtension.h"
#import "Student.h"
#import "JSONStudent.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSInteger i = 0; i<20; i++) {
        [self JSONStudent];
    }
    
}

- (NSDictionary *)getDic {
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"jack",@"name",
                         @"188",@"height", nil];
    return dic;
}

- (void)student {
    Student *stu = [Student mj_objectWithKeyValues:[self getDic]];
    NSLog(@"%@, %@", stu.name, stu.height);
}

- (void)JSONStudent {
    
    JSONStudent *stu = [JSONStudent parserEntityWithDictionary:[self getDic]];
    NSLog(@"%@, %@ -- ", stu.name, stu.height);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        JSONStudent *stu = [JSONStudent parserEntityWithDictionary:[self getDic]];
        NSLog(@"%@, %@ -- ", stu.name, stu.height);
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        JSONStudent *stu = [JSONStudent parserEntityWithDictionary:[self getDic]];
        NSLog(@"%@, %@ -- ", stu.name, stu.height);
    });
}


@end
