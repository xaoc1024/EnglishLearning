//
//  AnswersTableViewCell.m
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/22/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import "AnswersTableViewCell.h"

@interface AnswersTableViewCell ()
@property (nonatomic, strong) UIColor* normalColor;
@property (nonatomic, strong) UIColor* selectedColor;
@property (strong, nonatomic) IBOutlet UILabel *borderedBackgroundView;

@end

@implementation AnswersTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.borderedBackgroundView.backgroundColor = [UIColor clearColor];
    self.normalColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    self.selectedColor = [UIColor grayColor];
    self.borderedBackgroundView.layer.masksToBounds = YES;
    self.borderedBackgroundView.layer.cornerRadius = 10.0;
    self.borderedBackgroundView.layer.borderColor = [UIColor grayColor].CGColor;
    self.borderedBackgroundView.layer.borderWidth = 4.0;
}

- (void)setAnswerIsSelected:(BOOL)answerIsSelected
{
    _answerIsSelected = answerIsSelected;

    self.borderedBackgroundView.layer.borderColor = self.selectedColor.CGColor;
//    self.borderedBackgroundView.layer.borderColor = answerIsSelected ? self.selectedColor.CGColor : self.normalColor.CGColor;
    self.borderedBackgroundView.backgroundColor = answerIsSelected ? [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.8] : self.normalColor;
}

- (void)animateBackgroundForCorrectAnswer:(BOOL)correctAnswer
{
    UIColor* animationCollor = correctAnswer ?  [UIColor colorWithRed:0.1 green:0.8 blue:0.1 alpha:0.85] : [UIColor colorWithRed:1.0 green:0.1 blue:0.1 alpha:0.85];
    
        [UIView animateWithDuration:0.5 animations:^{
            self.borderedBackgroundView.backgroundColor = animationCollor;
            [self.borderedBackgroundView setNeedsLayout];
            [self.borderedBackgroundView layoutIfNeeded];
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.5 animations:^{
//                self.borderedBackgroundView.backgroundColor = self.normalColor;
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.5 animations:^{
//                    self.borderedBackgroundView.backgroundColor = animationCollor;
//                } completion:^(BOOL finished) {
////                    [UIView animateWithDuration:0.2 animations:^{
////                        self.borderedBackgroundView.backgroundColor = [UIColor whiteColor];
////                    }];
//                }];
//            }];
        }];
}

- (void)resetAppearance
{
    self.borderedBackgroundView.layer.borderColor = [UIColor grayColor].CGColor;
    self.borderedBackgroundView.backgroundColor = self.normalColor;
}


@end
