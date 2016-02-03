//
//  AddWordViewController.h
//  EnglishLearning
//
//  Created by Andriy Zhuk on 23.01.16.
//  Copyright © 2016 azhuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddWordViewController;

@protocol AddWordViewControllerDelegate <NSObject>

- (void)addWordViewControllerDidCandel:(AddWordViewController *)viewController;
- (void)addWordViewControllerDidAddAWord:(NSString *)originalWord withTranlation:(NSString *)translation andTranscription:(NSString *)transcription;

@end

@interface AddWordViewController : UITableViewController

@property (nonatomic, strong) id <AddWordViewControllerDelegate> delegate;

@end
