//
//  ViewController.m
//  JJ_Class_21_绘图_BEMLineGraphView
//
//  Created by Jay on 2016/10/15.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "ViewController.h"
#import "BEMSimpleLineGraphView.h"

#define UIColorFromRGBA(rgbValue, iAlpha) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:iAlpha]
#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0f)

#define kTipsTextColor                      UIColorFromRGB(0x9c9c9c)

#define kHighlightedTextColor               UIColorFromRGB(0xf36223)

@interface ViewController () <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (nonatomic, strong) BEMSimpleLineGraphView *currenGraph;

@property (nonatomic, strong, nullable) NSMutableArray *arrayOfValues;//Y轴列表

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutCurrenGraph];
}

#pragma mark - Private Methods
- (void)layoutCurrenGraph {
    [self setupCurrenGraph];
    
    [self.view addSubview:self.currenGraph];
}

- (void)setupCurrenGraph {
    //测试数据
    self.currenGraph.delegate = self;
    self.currenGraph.dataSource = self;
    self.currenGraph.colorTop = [UIColor clearColor];
    self.currenGraph.colorBottom = [UIColor colorWithRed:1.00f green:0.44f blue:0.25f alpha:1.00f];
    self.currenGraph.alphaBottom = 0.2f;
    self.currenGraph.colorLine = [UIColor colorWithRed:1.00f green:0.42f blue:0.22f alpha:1.00f];
    self.currenGraph.colorXaxisLabel = kTipsTextColor;
    self.currenGraph.widthLine = 0.5f;
    self.currenGraph.labelFont = [UIFont systemFontOfSize:9.0f];
    self.currenGraph.enableTouchReport = NO;
    self.currenGraph.enablePopUpReport = NO;
    self.currenGraph.enableBezierCurve = NO;
    self.currenGraph.enableYAxisLabel = NO;
    self.currenGraph.enableXAxisLabel = YES;
    self.currenGraph.autoScaleYAxis = YES;
    self.currenGraph.colorBackgroundXaxis = [UIColor whiteColor];
    self.currenGraph.alwaysDisplayDots = YES;
    self.currenGraph.sizePoint = 5;
    self.currenGraph.colorPoint = [UIColor colorWithRed:1.00f green:0.44f blue:0.25f alpha:1.00f];
    self.currenGraph.enableReferenceXAxisLines = NO;
    self.currenGraph.enableReferenceYAxisLines = NO;
    self.currenGraph.enableReferenceAxisFrame = YES;
    self.currenGraph.animationGraphStyle = BEMLineAnimationFade;
    self.currenGraph.enableRightReferenceAxisFrameLine = NO;
    self.currenGraph.widthReferenceLines = 1.5;
    self.currenGraph.colorReferenceLines = UIColorFromRGB(0xEDEDED);
    __weak typeof(self) weakSelf = self;
    self.currenGraph.complateBlock = ^(BOOL isFinished){
        [weakSelf setYAxisLabels];
    };
}

- (void)setYAxisLabels{
    CGRect  frame = CGRectMake(15, self.currenGraph.frame.size.height - 20, 30, 20);
    CGFloat stepValue = (11 - floor(7.5))/5 + 0.1;
    
    for (int i = 0; i < 6; i++) {
        NSString  *contentValue = [NSString stringWithFormat:@"%.2f",floor(7.5) + stepValue * (i)];
        UILabel  *labelY = [self newLabelWithText:contentValue frame:frame font:[UIFont systemFontOfSize:9.0f] textColor:kTipsTextColor];
        labelY.textAlignment = NSTextAlignmentRight;
        CGFloat  yPosition = [self.currenGraph yPositionForDotValue:[labelY.text doubleValue]];
        
        labelY.center = CGPointMake(-22, yPosition);
        [self.currenGraph addSubview:labelY];
    }
    
    
    for (int n = 2; n <[self.arrayOfValues count]; n+=3) {
        UILabel  *label_1 = [self newLabelWithText:[self.arrayOfValues objectAtIndex:n] frame:CGRectMake(0, 0, 28, 20) font:[UIFont systemFontOfSize:10.0f] textColor:kHighlightedTextColor];
        label_1.backgroundColor = [UIColor clearColor];
        label_1.textAlignment =NSTextAlignmentCenter;
        label_1.alpha  = 0;
        CGPoint  labelPoint = [self.currenGraph showLabelAtPoint:n];
        labelPoint.x = labelPoint.x;
        labelPoint.y = labelPoint.y - 10;
        label_1.center = labelPoint;
        [self.currenGraph addSubview:label_1];
        [UIView animateWithDuration:1.0f animations:^{
            label_1.alpha = 1.0f;
        }];
    }
    
    
}

- (UILabel *)newLabelWithText:(NSString*)text
                        frame:(CGRect)frame
                         font:(UIFont *)font
                    textColor:(UIColor *)textColor
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    if (text != nil) {
        label.text = text;
    }
    
    if (font != nil) {
        label.font = font;
    }
    
    if (textColor != nil) {
        label.textColor = textColor;
    }
    
    return label;
}

#pragma mark - <BEMSimpleLineGraphDataSource>

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {

    return (int)[self.arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    CGFloat  discountValue = 0.0f;
    if (index < self.arrayOfValues.count) {
        discountValue = [[self.arrayOfValues objectAtIndex:index] floatValue];
    }
    NSLog(@"lineGraph:%f", discountValue);
    return discountValue;
}

- (NSString *)noDataLabelTextForLineGraph:(BEMSimpleLineGraphView *)graph{
    NSLog(@"noDataLabelTextForLineGraph:暂无数据");
    return @"暂无数据";
}

#pragma mark - <BEMSimpleLineGraphDelegate>

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    NSLog(@"numberOfGapsBetweenLabelsOnLineGraph:%f", 0.0);
    return 0;
}

- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph{
    NSLog(@"numberOfYAxisLabelsOnLineGraph:8");
    return 8;
}


- (CGFloat)maxValueForLineGraph:(BEMSimpleLineGraphView *)graph{
    return  10.669718;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"%ld",index+1];
}

- (NSInteger)baseIndexForXAxisOnLineGraph:(BEMSimpleLineGraphView *)graph{
    NSLog(@"baseIndexForXAxisOnLineGraph:3");
    return 3;
}

-(CGFloat)staticPaddingForLineGraph:(BEMSimpleLineGraphView *)graph{
    NSLog(@"staticPaddingForLineGraph:65");
    return 65;
}


#pragma mark - Property
- (NSMutableArray *)arrayOfValues {
    if (_arrayOfValues == nil) {
        _arrayOfValues = [[NSMutableArray alloc] initWithObjects:
                          @"7.5",
                          @"7.6",
                          @"8.0",
                          @"8.1",
                          @"8.2",
                          @"9.0",
                          @"9.1",
                          @"9.2",
                          @"10.0",
                          @"10.1",
                          @"10.2",
                          @"11.0", nil];
    }
    return _arrayOfValues;
}

- (BEMSimpleLineGraphView *)currenGraph{
    if (_currenGraph == nil) {
        _currenGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(30, 100, 300, 180)];
    }
    return _currenGraph;
}

@end
