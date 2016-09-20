//
//  ViewController.m
//  JJ_Class_20_设计模式_观察者
//
//  Created by Jay on 2016/9/19.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "ViewController.h"
#import "WeatherData.h"
#import "CurrentConditionsDisplay.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self weatherStation];
}


#pragma mark- 标准的观察者模式

- (void)weatherStation {
    WeatherData *weatherData = [[WeatherData alloc] init];
    
    CurrentConditionsDisplay *currentDisplay = [[CurrentConditionsDisplay alloc] init];
    [weatherData registerObserver:currentDisplay];
    
    [weatherData setMeasurementsTemp:80 humidity:65 pressure:34.5];
    [weatherData setMeasurementsTemp:90 humidity:65 pressure:34.5];
    [weatherData setMeasurementsTemp:100 humidity:65 pressure:34.5];
}

@end
