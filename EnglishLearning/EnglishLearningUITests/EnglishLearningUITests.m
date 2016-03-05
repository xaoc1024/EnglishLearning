//
//  EnglishLearningUITests.m
//  EnglishLearningUITests
//
//  Created by Andriy Zhuk on 11/21/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface EnglishLearningUITests : XCTestCase

@end

@implementation EnglishLearningUITests

- (void)setUp
{
    [super setUp];

    self.continueAfterFailure = NO;
    [[[XCUIApplication alloc] init] launch];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"Words list"] tap];
    
    XCUIApplication *app2 = app;
    [app2.tables.staticTexts[@"\u0447\u0435\u0440\u0435\u0432\u043d\u0438\u0439"] tap];
    
    XCUIElementQuery *tablesQuery = app.tables;
    XCUIElement *textField = [[[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:4] childrenMatchingType:XCUIElementTypeTextField].element;
    [textField tap];
    [textField typeText:@"q"];
}

@end
