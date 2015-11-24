//
//  AnswerButtonCell.m
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/22/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import "AnswerButtonCell.h"

@implementation AnswerButtonCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.checkButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.checkButton.layer.borderWidth = 2;
    
}
- (IBAction)checkButtonAction:(id)sender
{
    [self.delegate anserCellDidTapCheckButton:self];
}

@end
