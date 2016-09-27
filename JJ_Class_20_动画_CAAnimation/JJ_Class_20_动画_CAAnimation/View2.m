//
//  View2.m
//  JJ_Class_20_动画_CAAnimation
//
//  Created by Jay on 2016/9/23.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "View2.h"

@interface View2 () <CAAnimationDelegate>

@end

@implementation View2


#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // 取出动画类型
    NSString *type = [anim valueForKey:@"animationType"];
    
    if ([type isEqualToString:@"translationTo"]) {
        // 取出目标点 并 设置self.center
        self.center = [[anim valueForKey:@"targetPoint"] CGPointValue];
    }
    
}

#pragma mark - Private Methods

- (CGPoint)randomPoint
{
    // 获得父视图的大小
    CGSize size = self.superview.bounds.size;
    
    CGFloat x = arc4random_uniform(size.width);
    CGFloat y = arc4random_uniform(size.height);
    
    return CGPointMake(x, y);
}



#pragma mark - Public Methods

- (void)shakeAnimation
{
    // 1. 实例化关键帧动画
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    
    // 1> 角度
    CGFloat angel = M_PI_4 / 12.0;
    anim.values = @[@(angel), @(-angel), @(angel)];
    
    // 2> 循环晃
    anim.repeatCount = HUGE_VALF;
    
    // 3. 将动画添加到图层
    [self.layer addAnimation:anim forKey:nil];
}

//两个控制点
- (void)moveCurve2:(CFTimeInterval)duration to:(CGPoint)to
{
    // 1. 实例化关键帧动画
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // 2. 设置路径
    anim.duration = duration;
    
    // 中间的控制点使用屏幕上得随机点
    CGPoint cp1 = CGPointMake(100, 150);
    CGPoint cp2 = CGPointMake(200, 150);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    // 设置起始点
    CGPathMoveToPoint(path, NULL, self.center.x, self.center.y);
    // 添加带一个控制点的贝塞尔曲线
    CGPathAddCurveToPoint(path, NULL, cp1.x, cp1.y, cp2.x, cp2.y, to.x, to.y);
    
    anim.path = path;
    CGPathRelease(path);
    
    // 5) 设置键值记录目标位置，以便动画结束后，修正位置
    [anim setValue:@"translationTo" forKey:@"animationType"];
    [anim setValue:[NSValue valueWithCGPoint:to] forKey:@"targetPoint"];
    anim.delegate = self;
    
    anim.removedOnCompletion = NO;
    
    // 3. 将动画添加到图层
    [self.layer addAnimation:anim forKey:@"moveCurveWithDuration"];
}

//一个控制点
- (void)moveCurve1:(CFTimeInterval)duration to:(CGPoint)to
{
    // 1. 实例化关键帧动画
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // 2. 设置路径
    anim.duration = duration;
    
    // 中间的控制点使用屏幕上得随机点
    CGPoint cp = CGPointMake(100, 100);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    // 设置起始点
    CGPathMoveToPoint(path, NULL, self.center.x, self.center.y);
    // 添加带一个控制点的贝塞尔曲线
    CGPathAddQuadCurveToPoint(path, NULL, cp.x, cp.y, to.x, to.y);
    
    anim.path = path;
    CGPathRelease(path);
    
    // 5) 设置键值记录目标位置，以便动画结束后，修正位置
    [anim setValue:@"translationTo" forKey:@"animationType"];
    [anim setValue:[NSValue valueWithCGPoint:to] forKey:@"targetPoint"];
    anim.delegate = self;
    
    // 3. 将动画添加到图层
    [self.layer addAnimation:anim forKey:nil];
}

//按照矩形路径平移动画
// 移动的矩形是以当前点为矩形的一个顶点，目标点为矩形的对脚顶点
- (void)moveRectWithDuration:(CFTimeInterval)duration to:(CGPoint)to
{
    // 1. 实例化关键帧动画
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // 2. 按照矩形移动，需要使用到路径
    anim.duration = duration;
    
    // 1) 创建路径
    CGMutablePathRef path = CGPathCreateMutable();
    // 2) 设置路径内容
    // 起点，宽、高
    CGFloat w = to.x - self.center.x;
    CGFloat h = to.y - self.center.y;
    CGRect rect = CGRectMake(self.center.x, self.center.y, w, h);
    CGPathAddRect(path, nil, rect);
    
    // 3) 将路径添加到动画
    anim.path = path;
    
    // 4) 释放路径
    CGPathRelease(path);
    
    // 3. 将动画添加到图层
    [self.layer addAnimation:anim forKey:nil];
}

//使用随机中心点控制动画平移
- (void)moveWithDuration:(CFTimeInterval)duration to:(CGPoint)to controlPointCount:(NSInteger)cpCount
{
    // 1. 实例化关键帧动画
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // 2. 设置关键帧动画属性
    anim.duration = duration;
    
    // 设置values
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:cpCount + 2];
    
    // 1) 将起始点添加到数组
    [array addObject:[NSValue valueWithCGPoint:self.center]];
    
    // 2) 循环生成控制点位置数组
    for (NSInteger i = 0; i < cpCount; i++) {
        CGPoint p = [self randomPoint];
        
        [array addObject:[NSValue valueWithCGPoint:p]];
    }
    
    // 3) 将目标点添加到数组
    [array addObject:[NSValue valueWithCGPoint:to]];
    
    // 4) 设置values
    anim.values = array;
    
    // 5) 设置键值记录目标位置，以便动画结束后，修正位置
    [anim setValue:@"translationTo" forKey:@"animationType"];
    [anim setValue:[NSValue valueWithCGPoint:to] forKey:@"targetPoint"];
    anim.delegate = self;
    
    // 3. 将动画添加到图层
    [self.layer addAnimation:anim forKey:nil];
}

//移动到目标点
- (void)moveToPoint:(CGPoint)point
{
    // 1. 实例化关键帧动画
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // 2. 设置关键帧动画属性
    // 1) values
    // a. 让视图从当前点移动到屏幕的左上角
    // b. 再由左上角移动到用户点击的位置
    // 当前点
    NSValue *p1 = [NSValue valueWithCGPoint:self.center];
    NSValue *p2 = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    NSValue *p3 = [NSValue valueWithCGPoint:point];
    
    anim.values = @[p1, p2, p3];
    
    // 2) 时长
    anim.duration = 1;
    
    // 3) 设置键值记录目标位置，以便动画结束后，修正位置
    [anim setValue:@"translationTo" forKey:@"animationType"];
    [anim setValue:p3 forKey:@"targetPoint"];
    
    // 4) 设置代理
    anim.delegate = self;
    
    // 3. 将动画添加到图层
    [self.layer addAnimation:anim forKey:nil];
}



@end
