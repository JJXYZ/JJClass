//
//  RMAppDelegate.m
//  Rage Masters
//
//  Created by Canopus on 10/8/12.
//  Copyright (c) 2012 iOS Developer. All rights reserved.
//

#import "RMAppDelegate.h"
#import "RMMasterViewController.h"
#import "RMMaster.h"

#define kBaseURLString     @"https://sites.google.com/site/soheilsstudio/tutorials/ioscrashlogtutorial/"
#define kDirectoryFile     @"RageMastersPictureDirectory_16MB.bmp"
#define kDatasourceFile    @"Masters.plist"
#define kMasterNameKey     @"Name"
#define kMasterMasteryKey  @"Mastery"
#define kMasterLocationKey @"Location"
#define kMasterImageKey    @"Image"

#define kIsFirstRunKey     @"first run key"


@implementation RMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    BOOL isFirstRun = ![[NSUserDefaults standardUserDefaults] boolForKey:kIsFirstRunKey];
    if (isFirstRun) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsFirstRunKey];
        
        // Download the Rage Masters photo directory
        NSURL *url = [NSURL URLWithString:[kBaseURLString stringByAppendingPathComponent:kDirectoryFile]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#warning 修改一
        /**
         *  0x8badf00d: 读做 “ate bad food”! (把数字换成字母，是不是很像 :p)该编码表示应用是因为发生watchdog超时而被iOS终止的。  通常是应用花费太多时间而无法启动、终止或响应用系统事件。
         
         发现问题了吗? 异常编码是0x000000008badf00d,还有后面的报告:
         
         Application Specific Information:
         Soheil-Azarpour.Rage-Masters failed to launch in time
         Elapsed total CPU time (seconds): 8.030 (user 8.030, system 0.000), 20% CPU
         Elapsed application CPU time (seconds): 3.840, 10% CPU
         这说明应用在启动时就闪退了，iOS的watchdog机制终止了应用。帅! 找到问题了，但是为什会发生这样的事呢？
         接着往下看日志。 从下向上读回溯日志。最底下的帧 (frame 25: libdyld.dylib)是最先调用的，然后是帧24, Rage Masters, main (main.m:16) ，依此类推。
         跟应用源代码相关的帧是最重要的。忽略掉系统库和框架。下一个与代码相关的帧是:
         
         8    Rage Masters    0x0009f244 -[RMAppDelegate application:didFinishLaunchingWithOptions:] (RMAppDelegate.m:35)
         应用在执行RMAppDelegate (RMAppDelegate.m:35)类application:didFinishLaunchingWithOptions: 方法第35 行代码时闪退。打开Xcode看看那行代码：
         */
#if 0
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSURL *cacheDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSUserDirectory inDomains:NSCachesDirectory] lastObject];
        NSURL *filePath = [NSURL URLWithString:kDirectoryFile relativeToURL:cacheDirectory];
        [data writeToFile:[filePath absoluteString] atomically:YES];
#elif 1
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             NSURL *cacheDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSUserDirectory inDomains:NSCachesDirectory] lastObject];
             NSURL *filePath = [NSURL URLWithString:kDirectoryFile relativeToURL:cacheDirectory];
             [data writeToFile:[filePath absoluteString] atomically:YES];
         }];
#endif
        
        
    }
    
    
    NSMutableArray *masters = [NSMutableArray array];
    for (NSUInteger i = 0; i < 4; i++) {
        RMMaster *aMaster = [[RMMaster alloc] initWithName:[NSString stringWithFormat:@"name_%d", i] mastery:[NSString stringWithFormat:@"mastery_%d", i] location:[NSString stringWithFormat:@"location_%d", i] image:[UIImage imageNamed:@"icon"]];
        [masters addObject:aMaster];
    }
    
    
    RMMasterViewController *controller = (RMMasterViewController *)[[((UINavigationController *)self.window.rootViewController) viewControllers] lastObject];
    controller.masters = masters;
    
    
    // Override point for customization after application launch.
    return YES;
}



@end
