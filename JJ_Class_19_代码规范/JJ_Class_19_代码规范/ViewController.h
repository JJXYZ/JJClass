//
//  ViewController.h
//  JJ_Class_19_代码规范
//
//  Created by Jay on 2016/9/19.
//  Copyright © 2016年 JayJJ. All rights reserved.
//



/**
 行数限制 (建议)
 
 当函数长度超过80行后，应该将内部一些复杂的逻辑提炼出来，形成新的函数，然后调用 之，微型重构工作也应该无处不在，而不是等项目完成后再来重构。
 
 每行代码长度建议不超过120 建议每一行代码的长度超过120字符时做折行处理，处理时请以结构清晰为原则。
 
 每个类原则上不超过600行 一个类不应该将很多复杂的逻辑揉合到一起来实现， 我们约定当.m文件超过600行时，要考虑将这个文件进行拆分，可以使用类目(Category)的方法来分离功能代码。
 
 如果逻辑过于复杂，则应该考虑从设计上将一些内部可以独立的逻辑提炼出来，形成新的类，以减轻单一 类的复杂度。

 */

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *screenImageView;


/**
 publicFunction
 */
- (void)publicFunction;


/**
 loginResult

 @param isSuccess  isSuccess
 @param jsonObject jsonObject
 @param errorMsg   errorMsg
 @param errorCode  errorCode
 */
- (void)loginResult:(BOOL)isSuccess jsonObject:(id)jsonObject errorMsgDetail:(NSString *)errorMsg errorCode:(NSString *)errorCode;

@end

