//
//  ViewController.m
//  JJ_Class_13_运行时_Category
//
//  Created by Jay on 2018/7/26.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "ViewController.h"
#import "Person+Test.h"
#import "Person+Test2.h"
#import "Person+Eat.h"
#import "Student.h"
#import "Student+Test.h"
#import "Student+Test2.h"
#import "Teacher.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self personLoad];
}

#pragma mark - Private Methods

/** 命令行进入到存放Person+Test.m这个文件的文件夹中，然后在命令行输入clang -rewrite-objc Person+Test.m

    类
    struct objc_class : objc_object
 
    对象id
    typedef struct objc_object *id;
 
    SEL
    typedef struct objc_selector *SEL;
 
    IMP
    typedef id (*IMP)(id, SEL, …);
 
    Method
    typedef struct objc_method *Method;

 */
- (void)personFun {
    Person *person = [[Person alloc] init];
    [person run];
    [person test];
    [person eat];
}

- (void)personLoad {
//    [Person test];
}

- (void)personInitialize {
    [Teacher alloc];
    [Student alloc];
}

@end
