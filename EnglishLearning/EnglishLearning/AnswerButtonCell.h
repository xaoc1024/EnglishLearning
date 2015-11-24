//
//  AnswerButtonCell.h
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/22/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnswerButtonCell;

@protocol AnswerButtonCellDelegate <NSObject>

- (void)anserCellDidTapCheckButton:(AnswerButtonCell*)theCell;

@end

@interface AnswerButtonCell : UITableViewCell

@property (nonatomic, weak) id <AnswerButtonCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@end
