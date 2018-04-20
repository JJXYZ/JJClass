//
//  JJiOSInterview04.m
//  JJ_Class_25_2018_iOS面试题系列
//
//  Created by Jay on 2018/4/19.
//  Copyright © 2018年 com.xiaoniu88.XNOnline. All rights reserved.
//

#import "JJiOSInterview04.h"


/**
 一、如果后期需要增加数据库中的字段怎么实现，如果不使用 CoreData呢？
 编写SQL语句来操作原来表中的字段
 · 增加表字段
 ALTERTABLE 表名 ADDCOLUMN 字段名 字段类型;
 · 删除表字段
 ALTERTABLE 表名 DROPCOLUMN 字段名;
 · 修改表字段
 ALTERTABLE 表名 RENAMECOLUMN 旧字段名 TO 新字段名;
 
 二、SQLite数据存储是怎么用？
 · 添加SQLite动态库：
 · 导入主头文件：#import <sqlite3.h>
 · 利用C语言函数创建\打开数据库，编写SQL语句
 
 三、简单描述下客户端的缓存机制？
 1.缓存可以分为：内存数据缓存、数据库缓存、文件缓存
 2.每次想获取数据的时候
 3.先检测内存中有无缓存
 4.再检测本地有无缓存(数据库\文件)
 5.最终发送网络请求
 6.将服务器返回的网络数据进行缓存（内存、数据库、文件），以
 便下次读取
 
 四、你实现过多线程的Core Data么？NSPersistentStoreCoordinator，NSManagedObjectContext和 NSManagedObject中的哪些需要在线程中创建或者传递？你是用什么样的策略来实现的？
 1.CoreData是对SQLite数据库的封装
 2.CoreData中的NSManagedObjectContext在多线程中不安全
 3.如果想要多线程访问CoreData的话，最好的方法是一个线程一个NSManagedObjectContext
 4.每个NSManagedObjectContext对象实例都可以使用同一个
 NSPersistentStoreCoordinator实例，这是因为NSManagedObjectContext会在便用NSPersistentStoreCoordinator前上锁
 
 五、core data数据迁移
 iOS Core Data 数据迁移 指南
 
 六、FMDB的使用
 [iOS]数据库第三方框架FMDB详细讲解
 
 七、说说数据库的左连接和右连接的区别
 数据库左连接和右连接的区别：主表不一样通过左连接和右连接，最小条数为 3（记录条数较小的记录数)，最大条数为12(3 ×4）
 数据库中的左连接和右连接的区别
 
 八、了解Realm数据库吗？简要说一下数据迁移？
 Realm 于2014 年7月发布，是一个跨平台的移动数据库引擎，专门为移动应用的数据持久化而生。其目的是要取代 Core Data 和 SQLite。
 数据迁移：我们在更新版本的时候都会修改版本号或者构建号，判断版本号或者构建号是不是之前的值,在(application:didFinishLaunchingWithOptions:)中进行配置
 
 let bundleVersionString = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
 let bundleVersion = UInt64(bundleVersionString)!
 let configuration = Realm.Configuration(schemaVersion: bundleVersion, migrationBlock: { (migration, oldSchemaVersion) in
 print("Realm.Configuration", migration, oldSchemaVersion)
 })
 
 Realm.Configuration.defaultConfiguration = configuration
 OC - Realm数据库在iOS移动端的使用
 Swift - Realm数据库的使用详解（附样例）
 
 */
@implementation JJiOSInterview04

@end
