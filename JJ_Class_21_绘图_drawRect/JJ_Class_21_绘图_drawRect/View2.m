//
//  View2.m
//  JJ_Class_21_绘图_drawRect
//
//  Created by Jay on 2016/9/21.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "View2.h"

#pragma mark - 记录五角星的五个顶点
CGPoint points[5];

@interface View2()
{
    // 是否已经计算过五角星顶点
    BOOL _hasPoint;
}

@end

@implementation View2

#pragma mark 计算五角星初始的数组
- (void)loadPoints
{
    // 半径
    CGFloat r = 100;
    // 第一个点
    points[0] = CGPointMake(0,  - r);
    CGFloat angle = 4.0 * M_PI / 5.0;
    
    for (int i = 1; i < 5; i++) {
        // 下一目标点的坐标，相对的(0,0)计算的
        CGFloat x = cosf(i * angle - M_PI_2) * r;
        CGFloat y = sinf(i * angle - M_PI_2) * r;
        
        points[i] = CGPointMake(x, y);
    }
}

- (void)drawRect:(CGRect)rect
{
    if (!_hasPoint) {
        // 计算
        [self loadPoints];
        
        _hasPoint = YES;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawRandomStarWithContext:context count:16];
}

#pragma mark - 随机绘制N个五角星
- (void)drawRandomStarWithContext:(CGContextRef)context count:(NSInteger)count
{
    for (NSInteger i = 0; i < count; i++) {
        // 保存上下文
        CGContextSaveGState(context);
        // 平移上下文
        CGFloat x = arc4random() % 320;
        CGFloat y = arc4random() % 460;
        CGContextTranslateCTM(context, x, y);
        
        // 旋转上下文
        CGFloat angle = (arc4random() % 180) * M_PI / 180.0;
        CGContextRotateCTM(context, angle);
        
        // 缩放
        CGFloat scale = arc4random_uniform(5) / 10.0 + 0.5;
        CGContextScaleCTM(context, scale, scale);
        
        // 绘制五角星
        [self drawStar2:context];
        
        // 恢复上下文
        CGContextRestoreGState(context);
    }
}

#pragma mark - 绘制方法
- (UIColor *)randomColor
{
    /*
     r g b 0 ~ 1
     */
    CGFloat r = arc4random_uniform(255) / 255.0;
    CGFloat g = arc4random_uniform(255) / 255.0;
    CGFloat b = arc4random_uniform(255) / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

#pragma mark - 绘制五角星方法
- (void)drawStar2:(CGContextRef)context
{
    [[self randomColor]set];
    
    // 2) 起始点
    CGContextMoveToPoint(context, points[0].x, points[0].y);
    
    // 3) 设置路径，计算其他四个点的坐标
    // 技巧，一个一个计算调试，否则一下画太多点，不好调试！
    for (int i = 1; i < 5; i++) {
        // 下一目标点的坐标，相对的(0,0)计算的
        CGContextAddLineToPoint(context, points[i].x, points[i].y);
    }
    CGContextClosePath(context);
    
    // 4） 绘制五角星
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark - 直接绘制五角星
- (void)drawStar:(CGContextRef)context center:(CGPoint)center r:(CGFloat)r
{
    // 绘制五角星
    /*
     要绘制五角星需要以下条件：
     
     1. 圆心 center
     2. 半径 r
     3. 顶点 center.x, center.y - r
     4. 每次旋转 (2 * M_PI / 5.0) * 2.0 = 144 度
     */
    // 使用随机颜色
    [[self randomColor]set];
    
    // 1. 设置路径
    // 1) 初始条件
    //    CGPoint center = CGPointMake(160.0, 230.0);
    //    CGFloat r = 100.0;
    CGPoint point1 = CGPointMake(center.x, center.y - r);
    CGFloat angle = 4.0 * M_PI / 5.0;
    
    // 2) 起始点
    CGContextMoveToPoint(context, point1.x, point1.y);
    
    // 3) 设置路径，计算其他四个点的坐标
    // 技巧，一个一个计算调试，否则一下画太多点，不好调试！
    for (int i = 1; i < 5; i++) {
        // 下一目标点的坐标，相对的(0,0)计算的
        CGFloat x = cosf(i * angle - M_PI_2) * r;
        CGFloat y = sinf(i * angle - M_PI_2) * r;
        
        CGContextAddLineToPoint(context, x + center.x, y + center.y);
    }
    CGContextClosePath(context);
    
    
    // 4） 绘制五角星
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
