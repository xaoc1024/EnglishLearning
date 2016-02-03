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
    UIImage* image = [self.checkButton backgroundImageForState:UIControlStateNormal];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(28, 28, 28, 28)];
    
    [self.checkButton setBackgroundImage:image forState:UIControlStateNormal];
    
}
- (IBAction)checkButtonAction:(id)sender
{
    [self.delegate anserCellDidTapCheckButton:self];
}

@end
