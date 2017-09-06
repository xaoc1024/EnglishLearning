//
//  AnswersTableViewCell.h
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/22/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswersTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *answerLabel;

@property (nonatomic, assign) BOOL answerIsSelected;

- (void)animateBackgroundForCorrectAnswer:(BOOL)correctAnswer;

- (void)resetAppearance;

@end
