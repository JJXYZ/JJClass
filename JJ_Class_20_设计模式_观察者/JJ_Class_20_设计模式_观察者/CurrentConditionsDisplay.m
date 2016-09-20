//
//  CurrentConditionsDisplay.m
//  JJ_Class_20_设计模式_观察者
//
//  Created by Jay on 2016/9/20.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "CurrentConditionsDisplay.h"
#import "WeatherData.h"

@interface CurrentConditionsDisplay ()

@property (nonatomic, strong) WeatherData *weatherData;

@property (nonatomic, assign) float temprature;

@property (nonatomic, assign) float humidity;

@end

@implementation CurrentConditionsDisplay

#pragma mark - Life Cycle
- (instancetype)initWithWeatherData:(WeatherData *)weatherData {
    self = [super init];
    if (self) {
        self.weatherData = weatherData;
        [self.weatherData registerObserver:self];
    }
    return self;
}

#pragma mark - <Observer>

- (void)updateTemp:(float)temp humidity:(float)humidity pressure:(float)pressure {
    self.temprature = temp;
    self.humidity = humidity;
    [self display];
}

#pragma mark - <DisplayElement>

- (void)display {
    NSLog(@"CurrentConditionsDisplay %f %f", self.temprature, self.humidity);
}

@end
