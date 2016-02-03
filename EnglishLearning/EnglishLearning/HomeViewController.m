//
//  HomeViewController.m
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/28/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import "HomeViewController.h"
#import "Model.h"

static NSString* const kWordsQuizSegueIdentifier = @"WordsQuizSegueIdentifier";
static NSString* const kWordsListSegueIdentifier = @"WordsListSegueIdentifier";

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

// In a storyboard-based application, you will often want to do a little preparation before navigation
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
    [self performSegueWithIdentifier:kWordsQuizSegueIdentifier sender:self];
}

- (IBAction)wordsListButtonAction:(id)sender
{
    [self performSegueWithIdentifier:kWordsListSegueIdentifier sender:self];
}

@end
