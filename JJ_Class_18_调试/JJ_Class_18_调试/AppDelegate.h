//
//  AppDelegate.h
//  JJ_Class_18_调试
//
//  Created by Jay on 2016/9/27.
//  Copyright © 2016年 JayJJ. All rights reserved.
//






/**
 break NUM               在指定的行上设置断点。
 bt                      显示所有的调用栈帧。该命令可用来显示函数的调用顺序。
 clear                   删除设置在特定源文件、特定行上的断点。其用法为：clear FILENAME:NUM。
 continue                继续执行正在调试的程序。该命令用在程序由于处理信号或断点而导致停止运行时。
 display EXPR            每次程序停止后显示表达式的值。表达式由程序定义的变量组成。
 file FILE               装载指定的可执行文件进行调试。
 help NAME               显示指定命令的帮助信息。
 info break              显示当前断点清单，包括到达断点处的次数等。
 info files              显示被调试文件的详细信息。
 info func               显示所有的函数名称。
 info local              显示当函数中的局部变量信息。
 info prog               显示被调试程序的执行状态。
 info var                显示所有的全局和静态变量名称。
 kill                    终止正被调试的程序。
 list                    显示源代码段。
 make                    在不退出 gdb 的情况下运行 make 工具。
 next                    在不单步执行进入其他函数的情况下，向前执行一行源代码。
 print EXPR              显示表达式 EXPR 的值。
 print-object            打印一个对象
 print (int) name      打印一个类型
 print-object [artist description]   调用一个函数
 set artist = @"test"    设置变量值
 whatis                  查看变理的数据类型
 */





#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

