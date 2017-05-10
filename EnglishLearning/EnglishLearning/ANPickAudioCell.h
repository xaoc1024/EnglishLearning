//
//  ANPickAudioCell.h
//  Words Learning
//
//  Created by Andriy Zhuk on 3/11/16.
//  Copyright © 2016 azhuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ANPickAudioCell;

@protocol ANPickAudioCellDelegate <NSObject>

- (void)pickAudioCellDidPressPlay:(ANPickAudioCell*)cell;

@end


@interface ANPickAudioCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel* audioFileNameLabel;
@property (nonatomic, weak) id <ANPickAudioCellDelegate> delegate;

@end
