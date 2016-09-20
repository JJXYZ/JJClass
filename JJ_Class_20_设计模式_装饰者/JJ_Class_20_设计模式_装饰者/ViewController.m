//
//  ViewController.m
//  JJ_Class_20_设计模式_装饰者
//
//  Created by Jay on 2016/9/20.
//  Copyright © 2016年 JayJJ. All rights reserved.
//

#import "ViewController.h"
/** Beverage */
#import "Espresso.h"
#import "DarkRoast.h"
#import "HouseBlend.h"
/** Decorator */
#import "Mocha.h"
#import "Whip.h"
#import "Soy.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self HouseBlend];
}

- (void)Espresso {
    Beverage *beverage = [[Espresso alloc] init];
    NSLog(@"%@ %f", [beverage getDesccription], [beverage cost]);
}

- (void)DarkRoast {
    Beverage *beverage = [[DarkRoast alloc] init];
    beverage = [[Mocha alloc] initWithBeverage:beverage];
    beverage = [[Mocha alloc] initWithBeverage:beverage];
    beverage = [[Whip alloc] initWithBeverage:beverage];
    NSLog(@"%@ %f", [beverage getDesccription], [beverage cost]);
}

- (void)HouseBlend {
    Beverage *beverage = [[HouseBlend alloc] init];
    beverage = [[Soy alloc] initWithBeverage:beverage];
    beverage = [[Mocha alloc] initWithBeverage:beverage];
    beverage = [[Whip alloc] initWithBeverage:beverage];
    NSLog(@"%@ %f", [beverage getDesccription], [beverage cost]);
}


@end
