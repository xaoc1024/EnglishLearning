//
//  ViewController.m
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/21/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Word.h"
#import "WordsListTableViewCell.h"
#import "AddWordViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate, AddWordViewControllerDelegate>

@property (nonatomic, strong) Model* model;
@property (strong, nonatomic) IBOutlet UITableView *wordsTableView;
@property (nonatomic, strong) NSFetchedResultsController* fetchResultController;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic) NSArray* filteredArray;
@property (nonatomic) NSString* previouslySearchedString;

@end

@implementation ViewController

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
    
    NSMutableAttributedString* atrString = [[NSMutableAttributedString alloc] initWithString:word.originalWord attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:20], NSForegroundColorAttributeName: [UIColor blackColor]}];
   
    
    if (word.trnascrption.length > 0)
    {
        NSAttributedString* secondString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" \"%@\"", word.trnascrption] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:18], NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
        
        [atrString appendAttributedString:secondString];
        theCell.mainWordLabel.attributedText = atrString;
    }
    
    theCell.translationLabel.text = word.translatedWord;
    
    return theCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    self.searchBar.text = nil;
    [self.searchBar resignFirstResponder];

    self.filteredArray = self.fetchResultController.fetchedObjects;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddWordViewControllerSegue"])
    {
        UINavigationController* navigationController = (UINavigationController *)segue.destinationViewController;
        AddWordViewController *viewController = (AddWordViewController *)[navigationController viewControllers][0];
        viewController.delegate = self;
    }
}

#pragma mark - AddWordViewControllerDelegate

- (void)addWordViewControllerDidCandel:(AddWordViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addWordViewControllerDidAddAWord:(NSString *)originalWord withTranlation:(NSString *)translation andTranscription:(NSString *)transcription
{
    Word* word = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Word class]) inManagedObjectContext:self.model.managedObjectContext];

    word.originalWord = originalWord;
    word.translatedWord = translation;
    word.trnascrption = transcription;
    word.identifier = [[NSUUID UUID] UUIDString];
    word.user = self.model.user;

    [self.model saveContext];

    [self dismissViewControllerAnimated:YES completion:nil];
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
