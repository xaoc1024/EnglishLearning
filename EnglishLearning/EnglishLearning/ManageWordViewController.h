//
//  AddWordViewController.h
//  EnglishLearning
//
//  Created by Andriy Zhuk on 23.01.16.
//  Copyright © 2016 azhuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ManageWordViewController;

@protocol ManageWordWordViewControllerDelegate <NSObject>

- (void)manageWordViewControllerDidCandel:(ManageWordViewController *)viewController;
- (void)manageWordViewController:(ManageWordViewController *)viewController didAddAWord:(NSString *)originalWord withTranlation:(NSString *)translation andTranscription:(NSString *)transcription;

@end

@interface ManageWordViewController : UITableViewController

@property (nonatomic, strong) id <ManageWordWordViewControllerDelegate> delegate;

@property (nonatomic) NSString* originalWord;
@property (nonatomic) NSString* translation;
@property (nonatomic) NSString* transcription;

@end
