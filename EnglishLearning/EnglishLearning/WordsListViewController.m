//
//  ViewController.m
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/21/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import "WordsListViewController.h"
#import "Model.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Word.h"
#import "WordsListTableViewCell.h"
#import "ManageWordViewController.h"

static NSString* const kManageWordViewControllerSegueIdentifier = @"ManageWordViewControllerSegue";

@interface WordsListViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate, ManageWordWordViewControllerDelegate>

@property (nonatomic, strong) Model* model;
@property (strong, nonatomic) IBOutlet UITableView *wordsTableView;
@property (nonatomic, strong) NSFetchedResultsController* fetchResultController;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic) NSArray* filteredArray;
@property (nonatomic) NSString* previouslySearchedString;

@property (nonatomic) Word* editedWord;

@property (nonatomic, weak) ManageWordViewController* createWordViewController;
@property (nonatomic, weak) ManageWordViewController* editWordViewController;

@end

@implementation WordsListViewController

@synthesize filteredArray = _filteredArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.model = appDelegate.model;
    
    [self.wordsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([WordsListTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WordsListTableViewCellIdentifier"];
    
    self.wordsTableView.estimatedRowHeight = 74.0;
    self.wordsTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.model setupModelWithWord];
    self.wordsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kManageWordViewControllerSegueIdentifier])
    {
        ManageWordViewController *viewController = (ManageWordViewController *)segue.destinationViewController;
        viewController.delegate = self;

        if (self.editedWord != nil)
        {
            viewController.originalWord = self.editedWord.originalWord;
            viewController.translation = self.editedWord.translatedWord;
            viewController.transcription = self.editedWord.trnascrption;
            self.editWordViewController = viewController;
        }
        else
        {
            self.createWordViewController = viewController;
        }
    }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Word* word = self.filteredArray[indexPath.row];
    WordsListTableViewCell* theCell = [tableView dequeueReusableCellWithIdentifier:@"WordsListTableViewCellIdentifier"];
    
    theCell.mainWordLabel.text = word.originalWord;
    
    NSMutableAttributedString* atrString = [[NSMutableAttributedString alloc] initWithString:word.originalWord attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:20], NSForegroundColorAttributeName: [UIColor whiteColor]}];
   
    
    if (word.trnascrption.length > 0)
    {
        NSAttributedString* secondString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n(%@)", word.trnascrption] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:16], NSForegroundColorAttributeName: [UIColor colorWithRed:0.85 green:0.9 blue:0.95 alpha:1.0]}];
        
        [atrString appendAttributedString:secondString];
        theCell.mainWordLabel.attributedText = atrString;
    }
    
    theCell.translationLabel.text = word.translatedWord;
    
    return theCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    Word* word = self.filteredArray[indexPath.row];
    self.editedWord = word;
    self.view.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"ManageWordViewControllerSegue" sender:self];
        self.view.userInteractionEnabled = YES;
    });

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView beginUpdates];

        Word* word = self.filteredArray[indexPath.row];

        NSMutableArray* newArray = [NSMutableArray arrayWithArray:self.filteredArray];
        [newArray removeObjectAtIndex:indexPath.row];
        _filteredArray = [newArray copy];

        self.fetchResultController;
        [self.model.managedObjectContext deleteObject:word];
        [self.model saveContext];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        [tableView endUpdates];
    }


}

- (IBAction)addWordAction:(id)sender
{
    [self performSegueWithIdentifier:@"ManageWordViewControllerSegue" sender:self];
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

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.wordsTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.wordsTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {

    UITableView *tableView = self.wordsTableView;

    switch(type) {

        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    self.searchBar.text = nil;
    [self.searchBar resignFirstResponder];

    self.filteredArray = self.fetchResultController.fetchedObjects;
}

#pragma mark - ManageWordWordViewControllerDelegate

- (void)manageWordViewControllerDidCandel:(ManageWordViewController *)viewController
{
    if (viewController == self.editWordViewController)
    {
         self.editedWord = nil;
    }

    [self.navigationController popToViewController:self animated:YES];
}

- (void)manageWordViewController:(ManageWordViewController*)viewController didAddAWord:(NSString *)originalWord withTranlation:(NSString *)translation andTranscription:(NSString *)transcription
{
    Word* word = nil;

    if (viewController == self.createWordViewController)
    {
        word = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Word class]) inManagedObjectContext:self.model.managedObjectContext];
        word.user = self.model.user;
        word.identifier = [[NSUUID UUID] UUIDString];
    }
    else if (viewController == self.editWordViewController && self.editedWord != nil)
    {
        word = self.editedWord;
        self.editedWord = nil;
    }

    word.originalWord = originalWord;
    word.translatedWord = translation;
    word.trnascrption = transcription;

    [self.model saveContext];

    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark - UISearchBar

- (NSArray*)filteredArray
{
    if (_filteredArray == nil)
    {
        _filteredArray = self.fetchResultController.fetchedObjects;
    }

    return _filteredArray;
}

- (void)setFilteredArray:(NSArray *)filteredArray
{
    if (_filteredArray != filteredArray)
    {
        _filteredArray = filteredArray;

        [self.wordsTableView reloadData];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString* searchString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSPredicate* predicate = nil;
    if (searchString.length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"originalWord CONTAINS[cd] %@ OR translatedWord CONTAINS[cd] %@", searchString, searchString];
    }

    if (predicate != nil)
    {
        if (self.previouslySearchedString != nil && [searchString hasPrefix:self.previouslySearchedString])
        {
            self.filteredArray = [self.filteredArray filteredArrayUsingPredicate:predicate];
        }
        else
        {
            self.filteredArray = [self.fetchResultController.fetchedObjects filteredArrayUsingPredicate:predicate];
        }
    }
    else
    {
        self.filteredArray = self.fetchResultController.fetchedObjects;
    }

    self.previouslySearchedString = searchString;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    self.filteredArray = self.fetchResultController.fetchedObjects;
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

@end
