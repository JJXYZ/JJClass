//
//  NameFormatView.m
//  JJ_Class_19_代码规范
//
//  Created by Jay on 2016/10/2.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "NameFormatView.h"
//Entity
#import "XNOProductEntity.h"


/**
 变量名应使用容易意会的应用全称，且首字母小写，且使用首字母大写的形式分割单词。成员变量使用“_”做为前缀，以便和临时变量与属性区分。
 
 命名规范变量名称应直接体现出变量的类型.
 NSString           Str
 NSArray            Arr
 NSDictionary       Dic
 Entity             Entity
 UILabel            Label
 UIView             View
 UIImageView        ImageView
 */


@interface NameFormatView () <UIScrollViewDelegate> {
    BOOL _isScrollAnimation;
}

/** productEntity */
@property (nonatomic, strong) XNOProductEntity *productEntity;

/** dataArr */
@property (nonatomic, strong, readwrite) NSArray *dataArr;

/** showView */
@property (nonatomic, strong, readwrite) UIView *showView;

@end

@implementation NameFormatView



/**
 命名   （建议）
 
 ViewController：VC
 ViewModel：VM
 View：View
 Button：Btn
 Entity：Entity
 */

@end
