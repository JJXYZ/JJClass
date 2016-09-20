//
//  WeatherData.m
//  JJ_Class_20_设计模式_观察者
//
//  Created by Jay on 2016/9/20.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "WeatherData.h"

@interface WeatherData ()

@property (nonatomic, strong) NSMutableSet *observers;

@property (nonatomic, assign) float temprature;

@property (nonatomic, assign) float humidity;

@property (nonatomic, assign) float pressure;

@end

@implementation WeatherData


#pragma mark - Private Methods

- (void)measurementsChanged {
    [self notifyObservers];
}

#pragma mark - Public Methods

- (void)setMeasurementsTemp:(float)temp humidity:(float)humidity pressure:(float)pressure {
    self.temprature = temp;
    self.humidity = humidity;
    self.pressure = pressure;
    [self measurementsChanged];
}

#pragma mark - <Subject>

- (void)registerObserver:(id<Observer, DisplayElement>)observer {
    [self.observers addObject:observer];
}

- (void)removeObserver:(id<Observer, DisplayElement>)observer {
    [self.observers removeObject:observer];
}

- (void)notifyObservers {
    for (id<Observer, DisplayElement> observer in self.observers) {
        [observer updateTemp:self.temprature humidity:self.humidity pressure:self.pressure];
    }
}

#pragma mark - Property

- (NSMutableSet *)observers {
    if (!_observers) {
        _observers = [[NSMutableSet alloc] init];
    }    
    return _observers;
}


@end
