//
//  RMDirectoryBrowser.m
//  Rage Masters
//
//  Created by Canopus on 10/31/12.
//  Copyright (c) 2012 iOS Developer. All rights reserved.
//

#import "RMLollipopLicker.h"

#define COUNT 200

@interface RMLollipopLicker ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *lickedTimeLabel;
@end


@implementation RMLollipopLicker {
    NSOperationQueue *queue;
    NSMutableArray *lollipops;
}

#pragma mark - Life cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progressView.progress = 0.0;
    self.label.text = [NSString stringWithFormat:@"Tap on run and I'll lick a lollipop %d times!", COUNT];
    self.lickedTimeLabel.text = @"";
    
    lollipops = [[NSMutableArray alloc] init];
    queue = [[NSOperationQueue alloc] init];
}

/**
 *  这日志跟我们前面见到的相差很多。
 这个一个来自iOS 6的低内存崩溃日志。正如我们前面所说的，低内存崩溃日志与其他类型的崩溃日志很不一样，它们不指向特定的文件和代码行。相反，它们画出了闪退时设备上的内存使用情况的图表。
 至少，头部还是跟其他崩溃日志很像的:  提供了 Incident Identifier, CrashReporter Key, Hardware Model, OS Version等信息。
 接下来部分是低内存崩溃日志特有的:
 Free pages 指可用内存页数。每页大小约是4KB, 上面的日志中，可用内存约为3,872 KB (或者说 3.9 MB)。
 Purgeable pages 是那部分可被清除或重用的内存。在上面的日志中，是0KB。
 Largest process是闪退时使用大部分内存的应用名称，在上面的日志中，正是你的应用!
 Processes显示了闪退时各进程列表，还包含内存使用量。包含进程名 (第一列), 进程唯一标识符(第二名), 进程使用的内存页数(第三列)。最后一列是每个应用的状态。通常，发生闪退的应用的状态是 frontmost。 这里是 Rage Masters, 使用28591 页 (or 114.364 MB) 内存——这内存太多了!
 通过，最大进程和frontmost状态的应用是相同的， 而且也是引起低内存闪退的应用进程。但是也可能看到最大进程和 frontmost状态应用不同的例子。比如，如果最大进程是SpringBoard, 忽略它 , 因为 SpringBoard 进程是显示主屏幕的应用，出现在你双击home按钮等情况，而且它是一直活动的。
 低内存发生时，iOS向活动的应用发出低内存警告并终止后台应用。如果前台应用仍然继续增长内存，iOS将终止它。
 为了查找低内存问题的原因，你必需使用Instruments剖析应用。如果你不知道怎么做，可以看一下我们 一篇关于这个方面的教程.。 :] 另外, 你也可以走捷径，响应低内存警告通知，以解决部分闪退问题。
 回到Xcode查看RMLollipopLicker.m文件。 这是实现吃棒棒糖的视图控制器。看看源代码:
 */
- (void)didReceiveMemoryWarning {
    [lollipops removeAllObjects];
    [super didReceiveMemoryWarning];
}

- (void)lickLollipop {
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"Lollipop" withExtension:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:fileURL];
    NSString *lollipop = [dictionary objectForKey:@"Lollipop"];
    [lollipops addObject:lollipop];
}


#pragma mark - IBActions


- (IBAction)doneButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)runButtonPressed:(id)sender {
    
    [sender setEnabled:NO];
    [queue addOperationWithBlock:^{
        
        for (NSInteger i = 0 ; i <= COUNT ; i++) {
            [self lickLollipop];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                self.label.text = [NSString stringWithFormat:@"Licked a strawberry lollipop %d time(s)!", i];
                self.lickedTimeLabel.text = [NSString stringWithFormat:@"Licked the same lollipop %d time(s)!", lollipops.count-1];
                self.progressView.progress = (float)(i/COUNT);
                
                if (i >= COUNT) {
                    self.label.text = [NSString stringWithFormat:@"Tap on run and I'll lick a lollipop %d times!", COUNT];
                    self.progressView.progress = 0.0;
                    [sender setEnabled:YES];
                }
            }];
        }
    }];
    
}

@end
