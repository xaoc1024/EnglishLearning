//
//  QuizViewController.h
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/22/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ANCoreDataManager;

@interface QuizViewController : UIViewController
@property (nonatomic, strong) ANCoreDataManager* model;
@end
