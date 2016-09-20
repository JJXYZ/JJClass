//
//  View1.m
//  JJ_Class_21_绘图_drawRect
//
//  Created by Jay on 2016/9/20.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "View1.h"

@implementation View1

- (void)drawRect:(CGRect)rect
{
    [self drawArc];
}


#pragma mark - Image

// 在指定点绘制图像
// 提示：绘制之后，就无法改变位置，也没有办法监听手势识别
- (void)image_drawAtPoint {
    UIImage *image = [UIImage imageNamed:@"image1"];
    [image drawAtPoint:CGPointMake(100, 100)];
}

// 会在指定的矩形中拉伸绘制
- (void)image_drawInRect {
    UIImage *image = [UIImage imageNamed:@"image1"];
    [image drawInRect:CGRectMake(100, 100, 50, 50)];
}

// 在指定矩形区域中平铺图片
- (void)image_drawAsPatternInRect
{
    UIImage *image = [UIImage imageNamed:@"image1"];
    [image drawAsPatternInRect:CGRectMake(0, 0, 320, 460)];
}

#pragma mark - Text
// 在指定点绘制字符串
- (void)text_drawAtPoint
{
    NSString *string = @"Hello world";
    
    UIFont *font = [UIFont fontWithName:@"Marker Felt" size:20];
    UIColor *color = [UIColor purpleColor];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    NSDictionary *attributesDic = @{NSFontAttributeName:font,
                                    NSForegroundColorAttributeName:color,
                                    NSParagraphStyleAttributeName:style};
    
    [string drawAtPoint:CGPointMake(50, 100) withAttributes:attributesDic];
}

- (void)text_drawInRect
{
    NSString *string = @"Hello world";

    UIFont *font = [UIFont fontWithName:@"Marker Felt" size:20];
    UIColor *color = [UIColor purpleColor];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    NSDictionary *attributesDic = @{NSFontAttributeName:font,
                                    NSForegroundColorAttributeName:color,
                                    NSParagraphStyleAttributeName:style};
    
    CGRect rect = CGRectMake(50, 100, 210, 360);
    [[UIColor lightGrayColor] set];
    UIRectFill(rect);


    [string drawInRect:rect withAttributes:attributesDic];
}


#pragma mark - Arc
- (void)drawArc
{
    // 1. 取出上下文——当前绘图的位置（设备）
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSLog(@"%@", context);
    // 2. 设置路径
    /**
     CGContextAddArc(CGContextRef cg_nullable c, CGFloat x, CGFloat y,
     CGFloat radius, CGFloat startAngle, CGFloat endAngle, int clockwise)
     1) context 上下文
     2) x,y 是圆弧所在圆的中心点坐标
     3) radius 半径，所在圆的半径
     4) startAngle endAngle 起始角度和截止角度 单位是弧度
     0度 对应是圆的最右侧点
     5) clockwise 顺时针 0 或者逆时针 1
     */
    CGContextAddArc(context, 160, 230, 100, 0, -M_PI_2, 1);
    
    // 3. 绘制圆弧
    CGContextDrawPath(context, kCGPathStroke);
}

#pragma mark - 绘制圆形
- (void)drawShapeCicle
{
    // 1. 取出上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectMake(50, 50, 200, 100);
    
    // 2. 设置路径
    UIRectFrame(rect);
    CGContextAddEllipseInRect(context, rect);
    
    // 3. 绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark - 绘制矩形
- (void)drawShapeRect
{
    /**
     在程序开发中，无论肉眼看到的是什么形状的对象，其本质都是矩形的
     */
    CGRect rect = CGRectMake(50, 50, 200.0, 200.0);
    
    [[UIColor redColor]set];
    
    // 绘制实心矩形
    UIRectFill(rect);
    // 绘制空心矩形
    UIRectFrame(CGRectMake(50, 300, 100, 100));
}



#pragma mark 绘制直线
- (void)drawLine
{
    // 提示，使用Ref声明的对象，不需要用*
    // 1. 获取上下文-UIView对应的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 2. 创建可变的路径并设置路径
    /**
     注意：当我们开发动画的时候，通常需要指定对象运动的路线，然后由动画方法负责实现动画效果
     
     因此，在动画开发中，需要熟练使用路径
     */
    CGMutablePathRef path = CGPathCreateMutable();
    // 划线->
    // 1) 设置起始点
    CGPathMoveToPoint(path, NULL, 50, 50);
    // 2) 设置目标点
    CGPathAddLineToPoint(path, NULL, 200, 200);
    CGPathAddLineToPoint(path, NULL, 50, 200);
    
    // 3) 封闭路径
    // a) 直接指定目标点
    //    CGPathAddLineToPoint(path, NULL, 50, 50);
    // b) 使用关闭路径方法
    CGPathCloseSubpath(path);
    
    // 3. 将路径添加到上下文
    CGContextAddPath(context, path);
    
    // 4. 设置上下文属性
    /*
     设置线条颜色
     red  0 ~ 1.0  red / 255
     green 0 ~ 1.0 green / 255
     blue 0 ~ 1.0 blue / 255
     alpha 透明度 0 ~ 1.0
     0 - 完全透明
     1.0 - 完全不透名
     
     提示：
     1) 在使用rgb颜色设置时，最好不要同时指定 rgb 和 alpha，否则会对性能造成一定影响
     2) 默认线条和填充颜色都是黑色
     */
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 1.0);
    
    // 设置线条宽度
    CGContextSetLineWidth(context, 5.0);
    // 设置线条的顶点样式
    CGContextSetLineCap(context, kCGLineCapRound);
    // 设置线条的连接点样式
    CGContextSetLineJoin(context, kCGLineJoinRound);
    // 设置线条的虚线样式
    /**
     虚线的参数
     
     context
     phase 相位，虚线起始的位置，通常使用0即可，从头开始画虚线
     lengths 长度的数组
     count lengths数组的个数
     */
    CGFloat lengths[2] = {20.0, 10.0};
    CGContextSetLineDash(context, 0.0, lengths, 2);
    
    // 5. 绘制路径
    /**
     kCGPathStroke: 画线（空心）
     kCGPathFill:   填充（实心）
     kCGPathFillStroke: 即画线又填充
     */
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // 6. 释放路径
    CGPathRelease(path);
}

- (void)drawLine2
{
    // 1. 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 2. 设置当前上下文的路径
    // 1) 设置起始点
    CGContextMoveToPoint(context, 50, 50);
    // 2) 增加点
    CGContextAddLineToPoint(context, 200, 200);
    CGContextAddLineToPoint(context, 50, 200);
    // 3) 关闭路径
    CGContextClosePath(context);
    
    // 3 设置属性
    /*
     UIKit默认会导入Core Graphics框架，UIKit对常用的很多CG方法做了封装
     
     UIColor setStroke  设置边线颜色
     UIColor setFill    设置填充颜色
     UIColor set        设置边线和填充颜色
     */
    // 设置边线
    //    [[UIColor redColor] setStroke];
    // 设置填充
    //    [[UIColor blueColor] setFill];
    // 设置边线和填充
    [[UIColor greenColor] set];
    
    // 4 绘制路径，虽然没有直接定义路径，但是第2步操作，就是为上下文指定路径
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
