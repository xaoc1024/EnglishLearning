//
//  ANPickAudioCell.m
//  Words Learning
//
//  Created by Andriy Zhuk on 3/11/16.
//  Copyright © 2016 azhuk. All rights reserved.
//

#import "ANPickAudioCell.h"

@implementation ANPickAudioCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.audioFileNameLabel.text = nil;
}

- (IBAction)playButtonAction:(id)sender
{
    [self.delegate pickAudioCellDidPressPlay:self];
}

@end
