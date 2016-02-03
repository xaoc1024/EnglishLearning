//
//  AddWordViewController.m
//  EnglishLearning
//
//  Created by Andriy Zhuk on 23.01.16.
//  Copyright © 2016 azhuk. All rights reserved.
//

#import "AddWordViewController.h"
#import "Word.h"

@interface AddWordViewController () <UITextFieldDelegate>
@property (nonatomic) IBOutlet UITextField *originalWordTextField;
@property (nonatomic) IBOutlet UITextField *translationTextField;
@property (nonatomic) IBOutlet UITextField *transcriptionTextField;

@property (nonatomic) NSString* originalWord;
@property (nonatomic) NSString* translation;
@property (nonatomic) NSString* transcription;

@end

@implementation AddWordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

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
        [self.delegate addWordViewControllerDidAddAWord:self.originalWord withTranlation:self.translation andTranscription:self.transcription];
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
    [self.delegate addWordViewControllerDidCandel:self];
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
