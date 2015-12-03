//
//  HomeViewController.m
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/28/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import "HomeViewController.h"
#import "Model.h"
#import "HomeTableViewCell.h"

static NSString* const kWordsQuizSegueIdentifier = @"WordsQuizSegueIdentifier";
static NSString* const kWordsListSegueIdentifier = @"WordsListSegueIdentifier";

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, HomeTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray* titlesArray;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomeTableViewCellIdentifier"];
    
    self.titlesArray = @[@"Quiz", @"Word list"];
    
    self.tableView.estimatedRowHeight = 53.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCellIdentifier"];
    [cell.actionButton setTitle:self.titlesArray[indexPath.row] forState:UIControlStateNormal];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - HomeTableViewCellDelegate

- (void)cellDidReceiveAction:(HomeTableViewCell *)theCell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:theCell];
    
    if (indexPath.row == 0)
    {
        [self performSegueWithIdentifier:kWordsQuizSegueIdentifier sender:self];
    }
    else if (indexPath.row == 1)
    {
        [self performSegueWithIdentifier:kWordsListSegueIdentifier sender:self];
    }
}

@end
