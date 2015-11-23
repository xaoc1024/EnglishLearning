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
    self.normalColor = [UIColor blackColor];
    self.selectedColor = [UIColor lightGrayColor];
    self.borderedBackgroundView.layer.masksToBounds = YES;
    self.borderedBackgroundView.layer.cornerRadius = 10.0;
    self.borderedBackgroundView.layer.borderColor = self.normalColor.CGColor;
    self.borderedBackgroundView.layer.borderWidth = 4.0;
}

- (void)setAnswerIsSelected:(BOOL)answerIsSelected
{
    _answerIsSelected = answerIsSelected;
    
    self.borderedBackgroundView.layer.borderColor = answerIsSelected ? self.selectedColor.CGColor : self.normalColor.CGColor;
}

- (void)animateBackgroundForCorrectAnswer:(BOOL)correctAnswer
{
    UIColor* animationCollor = correctAnswer ?  [UIColor greenColor] : [UIColor redColor];
    
        [UIView animateWithDuration:0.5 animations:^{
            self.borderedBackgroundView.backgroundColor = animationCollor;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.borderedBackgroundView.backgroundColor = [UIColor whiteColor];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.borderedBackgroundView.backgroundColor = animationCollor;
                } completion:^(BOOL finished) {
//                    [UIView animateWithDuration:0.2 animations:^{
//                        self.borderedBackgroundView.backgroundColor = [UIColor whiteColor];
//                    }];
                }];
            }];
        }];
}

- (void)resetAppearance
{
    self.borderedBackgroundView.layer.borderColor = self.normalColor.CGColor;
    self.borderedBackgroundView.backgroundColor = [UIColor whiteColor];
}


@end
