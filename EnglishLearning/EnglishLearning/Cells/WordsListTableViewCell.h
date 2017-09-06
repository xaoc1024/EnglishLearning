//
//  WordsListTableViewCell.h
//  EnglishLearning
//
//  Created by Andriy Zhuk on 03.12.15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordsListTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel *mainWordLabel;
@property (nonatomic) IBOutlet UILabel *transcriptionLabel;

@property (nonatomic) IBOutlet UILabel *translationLabel;
@property (nonatomic) IBOutlet UILabel* infoLabel;

@end
