//
//  WordsListTableViewCell.h
//  EnglishLearning
//
//  Created by Andriy Zhuk on 03.12.15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordsListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *mainWordLabel;
@property (strong, nonatomic) IBOutlet UILabel *transcriptionLabel;

@property (strong, nonatomic) IBOutlet UILabel *translationLabel;

@end
