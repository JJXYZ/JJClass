//
//  View4.m
//  JJ_Class_21_绘图_drawRect
//
//  Created by Jay on 2016/10/19.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "View4.h"

@implementation View4

- (void)drawRect:(CGRect)rect {
//    [self drawShapeRect:rect];
}


#pragma mark - 边框

- (void)drawShapeRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    [[UIColor redColor] set];
    
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(context, rect.origin.x, rect.size.width);
    CGContextAddLineToPoint(context, rect.size.height, rect.size.width);
//    CGContextAddLineToPoint(context, rect.origin.x, rect.size.height);
    
//    CGContextClosePath(context);

    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
