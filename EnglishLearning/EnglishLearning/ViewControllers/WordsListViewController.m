//
//  ViewController.m
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/21/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import "WordsListViewController.h"
#import "ANCoreDataManager.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Word+CoreDataClass.h"
#import "WordsListTableViewCell.h"
#import "ANEditWordViewController.h"

static NSString* const kANManageWordViewControllerSegueIdentifier = @"EditWordViewControllerSegue";

@interface WordsListViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate, ANEditWordViewControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) ANCoreDataManager* model;
@property (strong, nonatomic) IBOutlet UITableView* wordsTableView;
@property (nonatomic, strong) NSFetchedResultsController* fetchResultController;

@property (strong, nonatomic) IBOutlet UISearchBar* searchBar;

@property (nonatomic) Word* editedWord;

@property (nonatomic, weak) ANEditWordViewController* editWordViewController;

@end

@implementation WordsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.model = appDelegate.model;

    self.wordsTableView.estimatedRowHeight = 74.0;
    self.wordsTableView.rowHeight = UITableViewAutomaticDimension;

    self.wordsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; \

    self.navigationController.delegate = self;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kANManageWordViewControllerSegueIdentifier])
    {
        ANEditWordViewController* viewController = (ANEditWordViewController*)segue.destinationViewController;
        if (self.editedWord != nil)
        {
            viewController.originalWord = self.editedWord.originalWord;
            viewController.translation = self.editedWord.translation;
            viewController.transcription = self.editedWord.transcription;
        }

        viewController.delegate = self;
    }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.fetchResultController.sections.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchResultController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    Word* word = [self.fetchResultController objectAtIndexPath:indexPath];
    WordsListTableViewCell* theCell = [tableView dequeueReusableCellWithIdentifier:@"WordsListTableViewCellIdentifier"];

    [self configureCell:theCell withWord:word];

    return theCell;
}

- (void)configureCell:(WordsListTableViewCell*)theCell withWord:(Word*)word
{
    theCell.mainWordLabel.text = word.originalWord;

    if (word.totalAnswers.integerValue > 0)
    {
        NSInteger correctAnswers = word.correctAnswers.integerValue;
        NSInteger totalAnswers = word.totalAnswers.integerValue;
        CGFloat percentRation = 0.0;
        if (totalAnswers > 0)
        {
            percentRation = (correctAnswers / totalAnswers) * 100.0;
        }

        theCell.infoLabel.text = [NSString stringWithFormat:@"%ld/%ld (%.0f%%)", (long)correctAnswers, (long)totalAnswers, percentRation];
    }
    else
    {
        theCell.infoLabel.text = nil;
    }

    theCell.translationLabel.text = word.translation;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    Word* word = [self.fetchResultController objectAtIndexPath:indexPath];
    self.editedWord = word;

    [self performSegueWithIdentifier:kANManageWordViewControllerSegueIdentifier sender:self];
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return YES;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Word* wordObject = [self.fetchResultController objectAtIndexPath:indexPath];

        [self.model.managedObjectContext deleteObject:wordObject];
        [self.model saveContext];
    }
}

- (IBAction)addWordAction:(id)sender
{
//    self.editedWord = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Word class]) inManagedObjectContext:self.model.managedObjectContext];
//    self.editedWord.user = self.model.user;
//
//    self.editedWord.creationDate = [NSDate date];

    [self performSegueWithIdentifier:kANManageWordViewControllerSegueIdentifier sender:self];
}

#pragma mark - fetchResultController

- (NSFetchedResultsController*)fetchResultController
{
    if (_fetchResultController == nil)
    {
        NSFetchRequest* fetchRequest = [NSFetchRequest new];

        NSEntityDescription* entity = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:self.model.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"originalWord" ascending:YES selector:@selector(caseInsensitiveCompare:)];

        [fetchRequest setSortDescriptors:@[sortDescriptor]];


        _fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.model.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _fetchResultController.delegate = self;

        NSError* error = nil;
        if (![_fetchResultController performFetch:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }

    return _fetchResultController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller
{
    [self.wordsTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath*)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath*)newIndexPath
{

    UITableView* tableView = self.wordsTableView;

    switch (type)
    {

        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withWord:(Word*)anObject];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    [self.wordsTableView endUpdates];
}

#pragma mark - ManageWordWordViewControllerDelegate

- (void)editWordViewControllerDidCandel:(ANEditWordViewController*)viewController
{
    if (self.editedWord.originalWord.length == 0 || self.editedWord.translation.length == 0)
    {
        [self.model.managedObjectContext deleteObject:self.editedWord];
    }

    [self.model saveContext];
    self.editedWord = nil;
}

- (void)editWordViewController:(ANEditWordViewController*)viewController didFinishWithOriginalWord:(NSString*)originalWord translation:(NSString*)translation transcription:(NSString*)transcription
{
    Word* word = self.editedWord;

    if (self.editedWord == nil)
    {
        word = [NSEntityDescription insertNewObjectForEntityForName:@"Word" inManagedObjectContext:self.model.managedObjectContext];
        word.creationDate = [NSDate date];
    }

    // fill word
    word.originalWord = originalWord;
    word.transcription = transcription;
    word.translation = translation;

    // save context
    [self.model saveContext];

    // nullify property
    self.editedWord = nil;

    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark - UISearchBar

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{
    NSString* searchString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self makeFilteringForSearchText:searchString];
}

- (void)makeFilteringForSearchText:(NSString*)searchString
{
    NSPredicate* predicate = nil;

    if (searchString.length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"originalWord CONTAINS[cd] %@ OR translation CONTAINS[cd] %@", searchString, searchString];
    }

    self.fetchResultController.fetchRequest.predicate = predicate;
    NSError* error = nil;
    [self.fetchResultController performFetch:&error];

    if (error != nil)
    {
        NSLog(@"%@", error);
    }

    [self.wordsTableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar
{
    searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar*)searchBar
{
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self searchBar:searchBar textDidChange:@""];

    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - UINavigationDelegate

- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    if (viewController == self)
    {
        self.editedWord = nil;
    }
}

@end
