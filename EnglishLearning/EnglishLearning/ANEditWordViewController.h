//
//  AddWordViewController.h
//  EnglishLearning
//
//  Created by Andriy Zhuk on 23.01.16.
//  Copyright © 2016 azhuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ANEditWordViewController;
@class Word;

@protocol ANEditWordViewControllerDelegate <NSObject>

- (void)editWordViewControllerDidCandel:(ANEditWordViewController *)viewController;

//- (void)editWordViewController:(ANEditWordViewController *)viewController didFinishEditingWord:(Word*)word;

- (void)editWordViewController:(ANEditWordViewController *)viewController didFinishWithOriginalWord:(NSString*)originalWord translation:(NSString*)translation transcription:(NSString*)transcription audioFilePath:(NSURL*)audioFilePath;

@end

@interface ANEditWordViewController : UITableViewController

@property (nonatomic, strong) id <ANEditWordViewControllerDelegate> delegate;

@property (nonatomic) NSString* originalWord;
@property (nonatomic) NSString* translation;
@property (nonatomic) NSString* transcription;

@property (nonatomic) NSURL* audioFileURL;

@end
