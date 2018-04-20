//
//  JJOCInterview3.m
//  JJ_Class_25_2018_iOS面试题系列
//
//  Created by Jay on 2018/4/19.
//  Copyright © 2018年 com.xiaoniu88.XNOnline. All rights reserved.
//

#import "JJOCInterview3.h"


/**
 1. When to use NSMutableArray and when to use NSArray?
 1> 当数组元素需要动态地添加或者删除时，用NSMutableArray
 2> 当数组元素固定不变时，用NSArray
 
 2. Give us example of what are delegate methods and what are data source methods of uitableview.
 1> 代理方法：返回tableView每行的高度、监听tableView每行的选中
 2> 数据源方法：返回tableView数据的组数和行数、每行显示什么数据
 
 3. How many autoreleasepool you can create in your application? Is there any limit?
 没有限制
 
 4. If we don’t create any autorelease pool in our application then is there any autorelease pool already provided to us?
 系统会默认会不定时地创建和销毁自动释放池
 
 5. When you will create an autorelease pool in your application?
 当不需要精确地控制对象的释放时间时，可以手动创建自动释放池
 
 6. When retain count increase?
 当做一次retain或者copy操作，都有可能增加计数器
 
 7. What are commonly used NSObject class methods?
 NSObject常见的类方法有：alloc、new、description等
 
 8. What is convenience constructor?
 像NSStirng的stringWithFormat，NSNumber的numberWithInt
 
 9. How to design universal application in Xcode?
 1> 创建项目时，Device选择Universal
 2> 可以创建一套痛用的数据模型
 3> 根据iPhone\iPad选择不同的控制器（iPad可能用UISplitViewController）
 4> 根据iPhone\iPad选择不同的界面
 
 10. What is keyword atomic in Objective C?
 1> atomic是原子性
 2> atomic会对set方法的实现进行加锁
 
 11. What are UIView animations?
 UIView封装的核心动画可以通过类方法\block实现
 
 12. How can you store data in iPhone applications?
 1> 属性列表
 2> Preference（NSUserDefaults）
 3> 键值归档（NSKeyedArchiver、NSCoding）
 4> SQLite数据库
 5> Core Data
 
 13. What is NSManagedObject model?
 NSManagedObject是Core Data中的实体对象
 
 14. What is predicate?
 谓词：可以以一定条件来过滤数组、字典等集合数据，也能用在Core Data的数据查询中
 
 */
@implementation JJOCInterview3

@end
