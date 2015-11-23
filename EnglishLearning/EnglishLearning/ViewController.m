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

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate>
@property (nonatomic, strong) Model* model;
@property (strong, nonatomic) IBOutlet UITableView *wordsTableView;
@property (nonatomic, strong) NSFetchedResultsController* fetchResultController;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.model = appDelegate.model;
    
    self.wordsTableView.estimatedRowHeight = 40.0;
    self.wordsTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.model setupModelWithWord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchResultController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseIdentifier = @"WordReuseIdentifier";
    
    Word* word = [self.fetchResultController objectAtIndexPath:indexPath];
    UITableViewCell* theCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (theCell == nil)
    {
        theCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    theCell.textLabel.text = [NSString stringWithFormat:@"%@ %@", word.identifier, word.originalWord];
    
    return theCell;
}

#pragma mark - fetchResultController

- (NSFetchedResultsController*)fetchResultController
{
    if (_fetchResultController == nil)
    {
        NSFetchRequest* fetchRequest = [NSFetchRequest new];
        
        NSEntityDescription* entity = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:self.model.managedObjectContext];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES]]];
        
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

- (void)controller:(NSFetchedResultsController*)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.wordsTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex + 1] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.wordsTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex + 1] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath*)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath*)newIndexPath
{
    UITableView* tableView = self.wordsTableView;
    
    NSIndexPath* correctedIndexPath = indexPath;
    NSIndexPath* correctedNewIndexPath = newIndexPath;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
        {
            [tableView insertRowsAtIndexPaths:@[correctedNewIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [tableView deleteRowsAtIndexPaths:@[correctedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            [tableView reloadRowsAtIndexPaths:@[correctedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
        case NSFetchedResultsChangeMove:
        {
            [tableView deleteRowsAtIndexPaths:@[correctedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[correctedNewIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    [self.wordsTableView endUpdates];
}

@end
