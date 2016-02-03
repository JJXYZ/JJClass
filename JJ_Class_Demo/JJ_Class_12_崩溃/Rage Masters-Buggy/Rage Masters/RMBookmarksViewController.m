//
//  RMBookmarksViewController.m
//  Rage Masters
//
//  Created by Canopus on 10/8/12.
//  Copyright (c) 2012 iOS Developer. All rights reserved.
//

#import "RMBookmarksViewController.h"

@implementation RMBookmarksViewController {
    NSMutableArray *bookmarks;
}


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get a copy of bookmarks from shared instance
    bookmarks = [[[RMBookmarks sharedBookmarks] bookmarks] mutableCopy];
    
    self.tableView.rowHeight = 80.0;
    [self.tableView setEditing:YES animated:NO];
    [self.tableView reloadData];
}


#pragma mark - UITableView data source and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return bookmarks.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    RMMaster *master = [bookmarks objectAtIndex:indexPath.row];
    cell.textLabel.text = master.name;
    cell.detailTextLabel.text = master.mastery;
    cell.imageView.image = master.image;
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /**
     *  这看起来跟前面那个崩溃日志很像。是另一个SIGABRT 异常。 你可能想知道是否是相同的问题：发送信息到一个没有实现相应方法的对象?
     让我们从回溯日志看看哪些方法被调用了。从底部开始，你的源代码最后被调用的是帧 6:
     
     6    Rage Masters    0x00088c66 -[RMBookmarksViewController tableView:commitEditingStyle:forRowAtIndexPath:] (RMBookmarksViewController.m:68)
     
     这是UITableViewDataSource 的一个方法. 呵呵?! 毫无疑问苹果已经实现了该方法 —— 你可以重载它, 但不像是还没有实现。而且,这是个可选的委派方法。 所以问题不是调用了一个没有实现的方法。
     再看看上面的几个帧:
     
     3    Foundation    0x346812aa -[NSAssertionHandler handleFailureInMethod:object:file:lineNumber:description:] + 86
     4    UIKit         0x37f04b7e -[UITableView(_UITableViewPrivate) _endCellAnimationsWithContext:] + 7690
     5    UIKit         0x3803a4a2 -[UITableView deleteRowsAtIndexPaths:withRowAnimation:] + 22
     帧 5, UITableView调用了它自己的另一个方法 deleteRowsAtIndexPaths:withRowAnimation: 然后是看起来像苹果内部方法的_endCellAnimationsWithContext: 被调用。然后Foundation framework发生异常handleFailureInMethod:object:file:lineNumber:description:.
     这些分析结合用户的抱怨，看起来是你在处理UITableView删除行过程中有Bug。回到Xcode。你知道看哪里吗 ? 能从崩溃日志中判断出来? 就是RMBookmarksViewController.m文件的第68行:
     */
    RMMaster *masterToDelete = [bookmarks objectAtIndex:indexPath.row];
    [bookmarks removeObject:masterToDelete];
    [[RMBookmarks sharedBookmarks] unbookmarkMaster:masterToDelete];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}



#pragma mark - IBActions


- (IBAction)doneButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
