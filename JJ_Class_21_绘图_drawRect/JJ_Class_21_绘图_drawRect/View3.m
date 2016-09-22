//
//  View3.m
//  JJ_Class_21_绘图_drawRect
//
//  Created by Jay on 2016/9/21.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "View3.h"

@implementation View3

- (void)drawRect:(CGRect)rect
{
    
    NSString *string = @"Hello world";
    
    UIFont *font = [UIFont systemFontOfSize:self.fontSize];
    UIColor *color = [UIColor purpleColor];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    NSDictionary *attributesDic = @{NSFontAttributeName:font,
                                    NSForegroundColorAttributeName:color,
                                    NSParagraphStyleAttributeName:style};
    
    [string drawInRect:rect withAttributes:attributesDic];
}

#pragma mark - Property

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self setNeedsDisplay];
}

@end
