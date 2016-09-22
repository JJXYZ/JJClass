//
//  ViewController.m
//  JJ_Class_01_RTLabel
//
//  Created by Jay on 16/8/25.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "ViewController.h"
#import "RTLabel.h"
#import "DemoTableViewController.h"

@interface ViewController () <RTLabelDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createRTLabel];
    
    [self clickVC1];
}

#pragma mark - Private Methods

- (void)createRTLabel {
//    NSString *text = @"<b>bold</b> and <i>italic</i> style";
    
//    NSString *text = @"<font face='HelveticaNeue-CondensedBold' size=20><u color=blue>underlined</u> <uu color=red>text</uu></font>";
    
    NSString *text = @"clickable link - \
    <a href='http://store.apple.com'>link to apple store</a> \n\
    <a href='http://www.google.com'>link to google</a> \n\
    <a href='http://www.yahoo.com'>link to yahoo</a> \n\
    <a href='https://github.com/honcheng/RTLabel'>link to RTLabel in GitHub</a> \n\
    <a href='http://www.wiki.com'>link to wiki.com website</a>";
    
//    NSString *text = @"<font face='HelveticaNeue-CondensedBold' size=20 color='#CCFF00'>Text with</font> <font face=AmericanTypewriter size=16 color=purple>different colours</font> <font face=Futura size=32 color='#dd1100'>and sizes</font>";
    
//    NSString *text = @"<font face='HelveticaNeue-CondensedBold' size=20 stroke=1>Text with strokes</font> ";
    
//    NSString *text = @"<font face='HelveticaNeue-CondensedBold' size=14><p align=justify><font color=red>JUSTIFY</font> Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Ut enim ad minim </p> <p align=left><font color=red>LEFT ALIGNED</font> veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p><br><p align=right><font color=red>RIGHT ALIGNED</font> Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p><br><p align=center><font color=red>CENTER ALIGNED</font> Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum</p></font> ";
    
//    NSString *text = @"<p indent=20>Indented bla bla <bi>bla bla bla bla</bi> bla bla bla bla bla bla bla</p>";
    
    RTLabel *rtLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10,100,300,100)];
    rtLabel.delegate = self;
    rtLabel.text = text;
    rtLabel.lineSpacing = 20.0;
    CGSize optimumSize = [rtLabel optimumSize];
    rtLabel.frame = CGRectMake(10, 100, 300, optimumSize.height);
    [self.view addSubview:rtLabel];
}

#pragma mark - RTLabelDelegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url {
    NSLog(@"%@", url);
}

#pragma mark - Event

- (IBAction)clickVC1 {
    DemoTableViewController *vc = [[DemoTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
