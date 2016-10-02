//
//  NameFormatView.h
//  JJ_Class_19_代码规范
//
//  Created by Jay on 2016/10/2.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

/**
 
 类之前的注释
 
 由objective-c中所有命名，应以能够清晰表达其含义为第一标准，命名长一点没关系，最主要的就是清晰。所有命名尽量使用英文，万不得已可以使用拼音。使用拼音时，类、协议可以用拼音首字母做前缀，如：TTN天天牛;
 */


#import <UIKit/UIKit.h>


/**
 由类的命名以前缀开始，如:XNO，除前缀外的第一单词首字母也需要大写，多个单词以单词首字母大写进行分割。
 
 类的命名首先应保证表达意思明确，能一眼看出这个类是做什么任务的，然后才考虑名字的长度(不要怕长)。
 
 协议的命名和类基本相同，协议命名末尾一般加上单词delegate来表示这是个代理协议的名 称，大部分情况下协议名可以直接在其相应的类名的尾部加上Delegate(Protocol)即可;
 
 类名:XNODataStatisticsManager，XNOPickerView
 
 协议名:XNOInvestmentDetailBottomViewDelegate，XNOServiceJSONFileProtocol，
 
 */
@protocol NameFormatViewDeleagte <NSObject>

@end

@interface NameFormatView : UIView

@end



