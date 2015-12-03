//
//  HomeTableViewCell.h
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/28/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeTableViewCell;

@protocol HomeTableViewCellDelegate <NSObject>

- (void)cellDidReceiveAction:(HomeTableViewCell*)theCell;

@end

@interface HomeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
@property (nonatomic, weak) id <HomeTableViewCellDelegate> delegate;
@end
