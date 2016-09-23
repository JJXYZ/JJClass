//
//  View2.h
//  JJ_Class_20_动画_CAAnimation
//
//  Created by Jay on 2016/9/23.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface View2 : UIView

//摇晃动画
- (void)shakeAnimation;

//贝塞尔曲线，两个控制点
- (void)moveCurveWithDuration:(CFTimeInterval)duration to:(CGPoint)to;

//贝塞尔曲线，一个控制点
- (void)moveQuadCurveWithDuration:(CFTimeInterval)duration to:(CGPoint)to;

//按照矩形路径平移动画
- (void)moveRectWithDuration:(CFTimeInterval)duration to:(CGPoint)to;

//使用随机中心点控制动画平移
- (void)moveWithDuration:(CFTimeInterval)duration to:(CGPoint)to controlPointCount:(NSInteger)cpCount;

//移动到目标点
- (void)moveToPoint:(CGPoint)point;

@end
