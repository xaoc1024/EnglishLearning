//
//  HomeViewController.h
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/28/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ANCoreDataManager;

@interface HomeViewController : UIViewController

@property (nonatomic, strong) ANCoreDataManager* model;

@end
