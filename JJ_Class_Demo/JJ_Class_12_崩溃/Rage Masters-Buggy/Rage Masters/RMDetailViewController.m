//
//  RMDetailViewController.m
//  Rage Masters
//
//  Created by Canopus on 10/8/12.
//  Copyright (c) 2012 iOS Developer. All rights reserved.
//

#import "RMDetailViewController.h"

#define kBookmarkImageON  [UIImage imageNamed:@"bookmark_on.png"];


@interface RMDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bookmarkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *masterImageView;
@property (weak, nonatomic)IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *masteryLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton;
@end


@implementation RMDetailViewController


#pragma mark - Managing the detail item


- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.nameLabel.text = self.master.name;
    self.masteryLabel.text = self.master.mastery;
    self.locationLabel.text = self.master.location;
    self.masterImageView.image = self.master.image;
    [self updateBookmarkImage];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateBookmarkImage {
    
    if (self.master.isBookmarked) {
        
        self.bookmarkImageView.image = kBookmarkImageON;
        [self.bookmarkButton setTitle:NSLocalizedString(@"Remove as my favorite!", @"Remove as my favorite!") forState:UIControlStateNormal];
    }
    else {
        
        self.bookmarkImageView.image = nil;
        [self.bookmarkButton setTitle:NSLocalizedString(@"Bookmark as my favorite!", @"Bookmark as my favorite!") forState:UIControlStateNormal];
    }
}


#pragma mark - IBActions
/**
 *  异常代码是SIGABRT。通常,  SIGABRT 异常是由于某个对象接收到未实现的消息引起的。 或者，用简单的话说，在某个对象上调用了不存在的方法。
 这种情况一般不会发生，因为A对象调用了B方法，如果B方法不存在，编译器会报错。但是，如果你是使用selector间接调用方法的，编译器则无法检测对象是否存在该方法了。
 回到崩溃日志。它指出闪退发生在编号为0的线程上。 这意味着很可能是在主线程上调用了某个对象没有实现的方法。
 如果你接着阅读回溯日志，会发现跟你的代码相关的只有帧22, main.m:16. 这没有多大帮助。 :[
 继续向上查看框架调用，出现这个:
 
 2    CoreFoundation    0x36c02e02 -[NSObject(NSObject) doesNotRecognizeSelector:] + 166
 这不是你自己写的代码。但至少它确认了是对象调用了一个没有实现的方法。
 回到RMDetailViewController.m文件, 因为那是书签按钮实现动作的地方。 找到书签功能代码:
 */
- (IBAction)bookmarkButtonPressed  {
    
    self.master.isBookmarked = !self.master.isBookmarked;
    
    // Update shared bookmarks
    if (self.master.isBookmarked)
        [[RMBookmarks sharedBookmarks] bookmarkMaster:self.master];
    else
        [[RMBookmarks sharedBookmarks] unbookmarkMaster:self.master];
    
    
    // and register it in shared bookmarks
    [[RMBookmarks sharedBookmarks] bookmarkMaster:self.master];
    
    // Update UI
    [self updateBookmarkImage];
}


- (IBAction)doFunkyStuffTapped:(id)sender {
    
    BOOL canDoFunkySuff = [[RMBookmarks sharedBookmarks] canDoFunkyStuff];
    if (canDoFunkySuff) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Funky" message:@"Liar Liar Pants On Fire" delegate:nil cancelButtonTitle:@"Ew!" otherButtonTitles:@"Bingo!", nil];
        [alert show];
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uhm!" message:@"Bookmark some to get funky!" delegate:nil cancelButtonTitle:@"Get out!" otherButtonTitles:@"Not me!", nil];
        [alert show];
    }
}
@end
