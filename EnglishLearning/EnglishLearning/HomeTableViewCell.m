//
//  HomeTableViewCell.m
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/28/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (IBAction)buttonAction:(id)sender
{
    [self.delegate cellDidReceiveAction:self];
}

@end
