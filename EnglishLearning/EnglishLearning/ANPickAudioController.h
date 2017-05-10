//
//  ANPickAudioController.h
//  Words Learning
//
//  Created by Andriy Zhuk on 3/11/16.
//  Copyright © 2016 azhuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ANPickAudioController;

@protocol ANPickAudioViewControllerDelegate <NSObject>

- (void)pickAudioViewController:(ANPickAudioController*)viewController didPickAudioAtURL:(NSURL*)audioUrl;

@end

@interface ANPickAudioController : UITableViewController

@property (nonatomic) NSArray* audioPathesArray;
@property (nonatomic, weak) id <ANPickAudioViewControllerDelegate> delegate;

@end
