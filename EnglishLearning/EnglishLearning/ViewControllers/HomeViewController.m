//
//  HomeViewController.m
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/28/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import "HomeViewController.h"
#import "ANCoreDataManager.h"

static NSString* const ANWordsQuizSegueIdentifier = @"WordsQuizSegueIdentifier";
static NSString* const ANWordsListSegueIdentifier = @"WordsListSegueIdentifier";

@interface HomeViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray* titlesArray;
@property (weak, nonatomic) IBOutlet UIButton *quizButton;
@property (weak, nonatomic) IBOutlet UIButton *wordsListButton;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage* image = [self.quizButton backgroundImageForState:UIControlStateNormal];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(25, 25, 25, 25)];
    
    [self.quizButton setBackgroundImage:image forState:UIControlStateNormal];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController* destinationController = segue.destinationViewController;
    if ([destinationController respondsToSelector:@selector(setModel:)])
    {
        [destinationController performSelector:@selector(setModel:) withObject:self.model];
    }
}

- (IBAction)quizButtonAction:(id)sender
{
    [self performSegueWithIdentifier:ANWordsQuizSegueIdentifier sender:self];
}

- (IBAction)wordsListButtonAction:(id)sender
{
    [self performSegueWithIdentifier:ANWordsListSegueIdentifier sender:self];
}

@end
