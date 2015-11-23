//
//  QuizViewController.m
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/22/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import "QuizViewController.h"
#import "Model.h"
#import "Word.h"
#import "AnswersTableViewCell.h"
#import "WordsQuizTopTableViewCell.h"
#import "AnswerButtonCell.h"
#import "AppDelegate.h"

static NSString* const kTopCellIdentifier = @"WordsQuizTableViewCellIdentifier";
static NSString* const kAnswersCellIdentifier = @"AnswersTableViewCellIdentifier";
static NSString* const kAnswersButtonCellIdentifier = @"AnswerButtonCellIdentifier";

@interface QuizViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *quizTableView;
@property (nonatomic, strong) NSArray* wordsArray;
@property (nonatomic, strong) NSMutableArray* answersArray;
@property (nonatomic, strong) Word* questionWord;

@property (nonatomic, assign) NSUInteger correctWordIndex;
@property (nonatomic, strong) NSMutableArray* wordNumbersArray;

@end

@implementation QuizViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.model = appDelegate.model;
    
    [self.quizTableView registerNib:[UINib nibWithNibName:@"AnswersTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kAnswersCellIdentifier];
    
    [self.quizTableView registerNib:[UINib nibWithNibName:@"WordsQuizTopTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kTopCellIdentifier];
    
    [self.quizTableView registerNib:[UINib nibWithNibName:@"AnswerButtonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kAnswersButtonCellIdentifier];
    
    self.quizTableView.estimatedRowHeight = 40;
    self.quizTableView.rowHeight = UITableViewAutomaticDimension;
    
    NSFetchRequest* wordsRequest = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    
    NSError* error = nil;
    self.wordsArray = [self.model.managedObjectContext executeFetchRequest:wordsRequest error:&error];
    
    self.wordNumbersArray = [NSMutableArray array];
    self.answersArray = [NSMutableArray array];
    
    [self prepareNextQuestions];
}

- (void)prepareNextQuestions
{
    self.wordNumbersArray = [NSMutableArray array];
    self.answersArray = [NSMutableArray array];
    
    while (self.wordNumbersArray.count < 4)
    {
        NSNumber* randomNumber = @(random() % self.wordsArray.count);
        BOOL exists = NO;
        
        for (NSNumber* previousNumber in self.wordNumbersArray)
        {
            if ([previousNumber isEqualToNumber:randomNumber])
            {
                exists = YES;
                break;
            }
        }
        
        if (!exists)
        {
            [self.wordNumbersArray addObject:randomNumber];
        }
    }
    
    for (NSNumber* number in self.wordNumbersArray)
    {
        [self.answersArray addObject:self.wordsArray[number.integerValue]];
    }
    
    NSInteger randowQuestionWordNumber = random() % 4;
    self.questionWord = self.answersArray[randowQuestionWordNumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    
    if (section == 0)
    {
        number = 1;
    }
    else if (section == 1)
    {
        number = 4;
    }
    else
    {
        number = 1;
    }
    
    return number;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    
    if (indexPath.section == 0)
    {
        WordsQuizTopTableViewCell* theCell = [tableView dequeueReusableCellWithIdentifier:kTopCellIdentifier forIndexPath:indexPath];
        theCell.questionLabel.text = self.questionWord.originalWord;
        theCell.transcriptionLabel.text = self.questionWord.trnascrption;
        cell = theCell;
    }
    else if (indexPath.section == 1)
    {
        Word* word = self.answersArray[indexPath.row];
        
        AnswersTableViewCell* theCell = [tableView dequeueReusableCellWithIdentifier:kAnswersCellIdentifier forIndexPath:indexPath];
        
        theCell.answerLabel.text = word.translatedWord;
        cell = theCell;
    }
    else
    {
        AnswerButtonCell* buttonCell = [tableView dequeueReusableCellWithIdentifier:kAnswersButtonCellIdentifier forIndexPath:indexPath];
        cell = buttonCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2)
    {
        [self prepareNextQuestions];
        [tableView reloadData];
    }
}

@end
