//
//  NotificationMacro.h
//  JJ_Class_19_代码规范
//
//  Created by Jay on 2016/10/2.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

/**
    宏和常量

    可以参考系统自带宏的命名，命名单词应该表达出该宏表示的是个什么值.
    常量的命名和变量基本一致，只是需要用小写字母k作为前缀，首字母大写来分割单词。
*/

#ifndef NotificationMacro_h
#define NotificationMacro_h

/** 通知的注释 */
#define XNO_NOTIFICATION_NETWORK_UNSAFE @"notification_network_unsafe"

/** 首次打开应用 */
#define XNO_CMD_URL_OPEN @"open.json"

/** 账户浮层 */
#define XNO_AccountHint_Key             @"XNO_AccountHint_Key_"

/** UUID、应用唯一标识 */
#define OpenSessionID                   @"opensessionId"

/** 正在刷新… */
#define kTableViewRefreshTextHeaderRefreshing @"正在刷新…"


static NSString *const kClassFileNameType = @".archive";
static NSString *const kClassArchiveKey = @"ArchiveKey";
static NSString *const kClassLastModifiedKey = @"LastModifiedKey";

#endif /* NotificationMacro_h */
