//
//  AddWordViewController.m
//  EnglishLearning
//
//  Created by Andriy Zhuk on 23.01.16.
//  Copyright © 2016 azhuk. All rights reserved.
//

#import "ANEditWordViewController.h"
#import "Word.h"

@interface ANEditWordViewController () <UITextFieldDelegate>
@property (nonatomic) IBOutlet UITextField *originalWordTextField;
@property (nonatomic) IBOutlet UITextField *translationTextField;
@property (nonatomic) IBOutlet UITextField *transcriptionTextField;

@end

@implementation ManageWordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    UIView* view = [[UIView alloc] initWithFrame:self.tableView.bounds];
    [view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]]];
    UIView* overlayView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    overlayView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [view addSubview:overlayView];

    self.tableView.backgroundView = view;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.originalWordTextField.text = self.originalWord;
    self.translationTextField.text = self.translation;
    self.transcriptionTextField.text = self.transcription;
}

- (IBAction)doneButtonAction:(id)sender
{
    [self.view endEditing:YES];

    if (self.originalWord.length > 0 && self.translation.length > 0)
    {
        [self.delegate manageWordViewController:self didAddAWord:self.originalWord withTranlation:self.translation andTranscription:self.transcription];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Not all required field filled" message:@"You need to enter all required data" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* okayAction =  [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okayAction];

        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)cancelButtonAction:(id)sender
{
    [self.delegate manageWordViewControllerDidCandel:self];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == self.originalWordTextField)
    {
        [self.translationTextField becomeFirstResponder];
    }
    else if (textField == self.translationTextField)
    {
        [self.transcriptionTextField becomeFirstResponder];
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.originalWordTextField)
    {
        self.originalWord = [self.originalWordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if (textField == self.transcriptionTextField)
    {
        self.transcription = [self.transcriptionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if (textField == self.translationTextField)
    {
        self.translation = [self.translationTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

@end
