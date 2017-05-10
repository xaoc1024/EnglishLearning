//
//  QuizViewController.m
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/22/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import "QuizViewController.h"
#import "ANCoreDataManager.h"
#import "Word.h"
#import "AnswersTableViewCell.h"
#import "WordsQuizTopTableViewCell.h"
#import "AnswerButtonCell.h"
#import "AppDelegate.h"

static NSString* const kTopCellIdentifier = @"WordsQuizTableViewCellIdentifier";
static NSString* const kAnswersCellIdentifier = @"AnswersTableViewCellIdentifier";
static NSString* const kAnswersButtonCellIdentifier = @"AnswerButtonCellIdentifier";

static const NSInteger kNumberOfWordsInTest = 4;

// TODO: implement check for amount of words in DB and prevent test if user has less that 4 words

@interface QuizViewController ()<UITableViewDataSource, UITableViewDelegate, AnswerButtonCellDelegate>

@property (nonatomic) IBOutlet UITableView *quizTableView;

@property (nonatomic) Word* questionWord;

@property (nonatomic) NSMutableArray* allWordsArray;
@property (nonatomic) NSMutableArray* answersArray;
@property (nonatomic) NSMutableArray* recentWords;

@property (nonatomic) NSIndexPath* selectedIndexPath;
@property (nonatomic) NSInteger recentWordsMaxCount;

@property (nonatomic, getter=isWaitingForNextWord) BOOL waitingForNextWord;

@property (nonatomic) AnswerButtonCell* answerButtonCell;
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
    
    self.quizTableView.estimatedRowHeight = 50.0;
    self.quizTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self fetchAllWords];

    self.recentWords = [NSMutableArray new];

    [self prepareNextQuestions];
}

- (void)fetchAllWords
{
    NSFetchRequest* wordsRequest = [NSFetchRequest fetchRequestWithEntityName:@"Word"];

    NSError* error = nil;
    self.allWordsArray = [[self.model.managedObjectContext executeFetchRequest:wordsRequest error:&error] mutableCopy];
    if (error != nil)
    {
        NSLog(@"Cannot fetch words. Error: %@", error);
    }

    self.recentWordsMaxCount = self.allWordsArray.count / 10;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.model saveContext];

    [super viewWillDisappear:animated];
}

- (void)resetTest
{
    self.waitingForNextWord = NO;
    [self.answerButtonCell.checkButton setTitle:@"Check" forState:UIControlStateNormal];

    self.answersArray = [NSMutableArray array];

    self.selectedIndexPath = nil;
    self.questionWord = nil;
}

- (void)prepareNextQuestions
{
    [self resetTest];

    NSUInteger allWordsCount = self.allWordsArray.count;
    while (self.answersArray.count < kNumberOfWordsInTest)
    {
        Word* randomWord = self.allWordsArray[arc4random() % allWordsCount];

        if (![self.answersArray containsObject:randomWord])
        {
            [self.answersArray addObject:randomWord];
        }
    }
    
    unsigned int randowQuestionWordNumber = arc4random() % kNumberOfWordsInTest;
    self.questionWord = self.answersArray[randowQuestionWordNumber];

    [self addWordToRecent:self.questionWord];


    [self.quizTableView reloadData];
}

- (void)addWordToRecent:(Word*)word
{
    [self.recentWords addObject:word];

    [self.allWordsArray removeObject:word];

    if (self.recentWords.count > self.recentWordsMaxCount)
    {
        [self.allWordsArray addObject:self.recentWords.firstObject];
        [self.recentWords removeObjectAtIndex:0];
    }
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
        theCell.transcriptionLabel.text = self.questionWord.transcription;
        cell = theCell;
    }
    else if (indexPath.section == 1)
    {
        Word* word = self.answersArray[indexPath.row];
        
        AnswersTableViewCell* theCell = [tableView dequeueReusableCellWithIdentifier:kAnswersCellIdentifier forIndexPath:indexPath];
        [theCell resetAppearance];
        theCell.answerLabel.text = word.translation;
        cell = theCell;
    }
    else
    {
        AnswerButtonCell* buttonCell = [tableView dequeueReusableCellWithIdentifier:kAnswersButtonCellIdentifier forIndexPath:indexPath];
        buttonCell.delegate = self;
        cell = buttonCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        AnswersTableViewCell* cell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
        cell.answerIsSelected = NO;
        
        cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.answerIsSelected = YES;

        self.selectedIndexPath = indexPath;
    }
}

- (void)answerCellDidTapCheckButton:(AnswerButtonCell*)theCell
{
    if (self.waitingForNextWord)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(prepareNextQuestions) object:nil];
        [self prepareNextQuestions];
    }

    if (self.selectedIndexPath != nil )
    {
        AnswersTableViewCell* cell = [self.quizTableView cellForRowAtIndexPath:self.selectedIndexPath];
        NSInteger correctIndex = [self.answersArray indexOfObject:self.questionWord];

        BOOL answerIsCorrect = correctIndex == self.selectedIndexPath.row;
        [cell animateBackgroundForCorrectAnswer:answerIsCorrect];
        
        NSIndexPath* correctIndexPath = [NSIndexPath indexPathForRow:correctIndex inSection:1];
        cell = [self.quizTableView cellForRowAtIndexPath:correctIndexPath];
        [cell animateBackgroundForCorrectAnswer:YES];

        self.questionWord.totalAnswers = @(self.questionWord.totalAnswers.integerValue + 1);

        if (answerIsCorrect)
        {
            self.questionWord.correctAnswers = @(self.questionWord.correctAnswers.integerValue + 1);
        }

        [self waitForNextWord];
    }
}

- (void)waitForNextWord
{
    self.waitingForNextWord = YES;
    [self.answerButtonCell.checkButton setTitle:@"Go to Next Word" forState:UIControlStateNormal];
    [self performSelector:@selector(prepareNextQuestions) withObject:nil afterDelay:2.0];
}

- (AnswerButtonCell*)answerButtonCell
{
    if (_answerButtonCell == nil)
    {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        _answerButtonCell = [self.quizTableView cellForRowAtIndexPath:indexPath];
    }
    return _answerButtonCell;
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2 || self.waitingForNextWord)
    {
        return nil;
    }

    return indexPath;
}

@end
