//
//  EnglishLearningTests.m
//  EnglishLearningTests
//
//  Created by Andriy Zhuk on 11/21/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ManageWordViewController.h"

@interface WordsTest : XCTestCase
@property (nonatomic, strong) ManageWordViewController* viewController;
@end

@interface ManageWordViewController (UnitTests)
@property (nonatomic) IBOutlet UITextField *originalWordTextField;
@property (nonatomic) IBOutlet UITextField *translationTextField;
@property (nonatomic) IBOutlet UITextField *transcriptionTextField;

- (void)doneButtonAction:(id)sender;

@end

@implementation WordsTest

- (void)setUp
{
    [super setUp];

    self.viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ManageWordViewControllerStoryboardID"];

    self.viewController.view.hidden = NO;
}

- (void)tearDown {
    self.viewController = nil;

    [super tearDown];
}

- (void)testViewDidLoad
{
    XCTAssertEqual(self.viewController.tableView.estimatedRowHeight, 50.0);
    XCTAssertEqual(self.viewController.tableView.rowHeight, UITableViewAutomaticDimension);
}

- (void)testPerformanceExample
{

    [self measureBlock:^{
        [self.viewController doneButtonAction:nil];
    }];
}

@end
