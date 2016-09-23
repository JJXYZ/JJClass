//
//  VC1.m
//  JJ_Class_20_动画_CAAnimation
//
//  Created by Jay on 2016/9/23.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "VC1.h"

@interface VC1 () <CAAnimationDelegate>

@property (nonatomic, strong) UIView *view1;

@end

@implementation VC1

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.view1];
}


#pragma mark - Private Methods

- (void)touchTranslation:(NSSet *)touches {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self.view];
    
    if (self.view1 == touch.view) {
        NSLog(@"点击");
    }
    
    // 将view1平移到手指触摸的目标点
    [self translationAnimationTo:location];
}

- (void)translationAnimationTo:(CGPoint)point
{
    // 1. 实例化动画
    // 如果没有指定图层的锚点（定位点）postion对应UIView的中心点
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // 2. 设置动画属性
    // 1) fromValue(view1的当前坐标) & toValue
    anim.toValue = [NSValue valueWithCGPoint:point];
    
    // 2) 动画的时长
    anim.duration = 1.0f;
    
    // 3) 设置代理
    anim.delegate = self;
    
    // 4) 让动画停留在目标位置
    /*
     提示：通过设置动画在完成后不删除，以及向前填充，可以做到平移动画结束后，
     UIView看起来停留在目标位置，但是其本身的frame并不会发生变化
     */
    anim.removedOnCompletion = NO;
    // forwards是逐渐逼近目标点
    anim.fillMode = kCAFillModeForwards;
    
    // 5) 要修正坐标点的实际位置可以利用setValue方法
    [anim setValue:[NSValue valueWithCGPoint:point] forKey:@"targetPoint"];
    [anim setValue:@"translationTo" forKey:@"animationType"];
    
    // 3. 将动画添加到图层
    // 将动画添加到图层之后，系统会按照定义好的属性开始动画，通常程序员不在与动画进行交互
    [self.view1.layer addAnimation:anim forKey:nil];
}


- (void)scaleAnimation
{
    // 1. 实例化基本动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 2. 设置动画属性
    anim.fromValue = @(1);
    anim.byValue = @(0.2);
    anim.toValue = @(0.5);
    // 自动翻转动画
//    anim.autoreverses = YES;
    
    // 动画时长
    anim.duration = 0.5f;
    
    anim.removedOnCompletion = NO;
    
    // 3. 将动画添加到图层
    [self.view1.layer addAnimation:anim forKey:nil];
}


- (void)touchRotation {
    // 判断view1是否已经开始旋转，如果已经旋转，就停止
    CAAnimation *anim = [self.view1.layer animationForKey:@"rotationAnim"];
    if (anim) {
        // 停动画
        //        [self.view1.layer removeAllAnimations];
        // 如果动画处于暂停，就继续，如果播放中就暂停
        // 可以根据view1.layer.speed来判断，speed == 0，暂停
        if (self.view1.layer.speed == 0.0) {
            [self resumeRotationAnimation];
        } else {
            [self pauseRotationAnimation];
        }
    } else {
        [self rotationAnimation];
    }
}

- (void)rotationAnimation
{
    // 1. 实例化基本动画
    // 默认按照z轴旋转
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    [self.view1.layer setAnchorPoint:CGPointMake(0, 0)];
    
    // 2. 设置动画属性
    // 不停的旋转
    // 1) 旋转一周
    anim.toValue = @(2 * M_PI);

    // 2) 不停的旋转 - 动画循环播放
    anim.repeatCount = HUGE_VALF;
    
    anim.duration = 0.5;
    
    // 3) 动画完成时删除
    // 对于循环播放的动画效果，一定要将removedOnCompletion设置为NO，否则无法恢复动画
    [anim setRemovedOnCompletion:NO];
    
    // 3. 添加动画
    // key可以随便指定，用于判断图层中是否存在该动画
    [self.view1.layer addAnimation:anim forKey:@"rotationAnim"];
}

- (void)resumeRotationAnimation {
    // 1. 将动画的时间偏移量作为暂停时的时间点
    CFTimeInterval pauseTime = self.view1.layer.timeOffset;
    // 2. 根据媒体时间计算出准确的启动动画时间，对之前暂停动画的时间进行修正
    CFTimeInterval beginTime = CACurrentMediaTime() - pauseTime;
    
    // 3. 要把偏移时间清零
    [self.view1.layer setTimeOffset:0.0];
    // 4. 设置图层的开始动画时间
    [self.view1.layer setBeginTime:beginTime];
    
    [self.view1.layer setSpeed:1.0];
}

- (void)pauseRotationAnimation {
    // 1. 取出当前的动画的时间点，就是要暂停的时间点
    CFTimeInterval pauseTime = [self.view1.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 2. 设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点
    [self.view1.layer setTimeOffset:pauseTime];
    
    // 3. 将动画的运行速度设置为0，动画默认的运行速度是1.0
    [self.view1.layer setSpeed:0.0];
}


#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchRotation];
}

#pragma mark - Property

- (UIView *)view1 {
    if (_view1) {
        return _view1;
    }
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    _view1.backgroundColor = [UIColor purpleColor];
    return _view1;
}


@end
