//
//  __Alcatraz___Xcode__Tests.m
//  使用Alcatraz来管理Xcode插件Tests
//
//  Created by Jay on 15/11/23.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface __Alcatraz___Xcode__Tests : XCTestCase

@end

@implementation __Alcatraz___Xcode__Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
