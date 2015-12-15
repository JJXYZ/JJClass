//
//  ViewController.m
//  JJ_Class_03_js
//
//  Created by Jay on 15/11/25.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *fontFamilies = [UIFont familyNames];
    for (NSString *fontFamily in fontFamilies)
    {
        NSArray *fontNames = [UIFont fontNamesForFamilyName:fontFamily];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
    
    
}

@end
