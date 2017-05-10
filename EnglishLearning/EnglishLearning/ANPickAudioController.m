//
//  ANPickAudioController.m
//  Words Learning
//
//  Created by Andriy Zhuk on 3/11/16.
//  Copyright © 2016 azhuk. All rights reserved.
//

#import "ANPickAudioController.h"
#import "ANPickAudioCell.h"
#import "ANOggPlayer.h"

@interface ANPickAudioController () <ANPickAudioCellDelegate, ANOggPlayerDelegate>

@property (nonatomic) NSString* selectedPath;
@property (nonatomic) NSIndexPath* selectedIndexPath;

@property (nonatomic) ANOggPlayer* player;
@property (strong, nonatomic) IBOutlet UIBarButtonItem* doneButton;

@end

@implementation ANPickAudioController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.selectedIndexPath = nil;
    self.doneButton.enabled = NO;

    self.tableView.estimatedRowHeight = 50.0;
    self.tableView.rowHeight = 50;
}

- (void)setAudioPathesArray:(NSArray*)audioPathesArray
{
    if (_audioPathesArray != audioPathesArray)
    {
        _audioPathesArray = audioPathesArray;
    }
}

- (void)setSelectedIndexPath:(NSIndexPath*)selectedIndexPath
{
    if (_selectedIndexPath != selectedIndexPath)
    {
        _selectedIndexPath = selectedIndexPath;

        self.doneButton.enabled = (selectedIndexPath != nil);
    }
}

#pragma mark - UITalbeViewDatasourse

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.audioPathesArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    ANPickAudioCell* cell = (ANPickAudioCell*)[tableView dequeueReusableCellWithIdentifier:@"AudioPickingCellIdentifier" forIndexPath:indexPath];

    cell.accessoryType = UITableViewCellAccessoryNone;

    if ([indexPath isEqual:self.selectedIndexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    cell.audioFileNameLabel.text = [[self.audioPathesArray[indexPath.row] absoluteString] lastPathComponent];
    cell.delegate = self;

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndexPath = indexPath;

    [tableView reloadData];
}

- (IBAction)doneButtonAction:(id)sender
{
    if (self.selectedIndexPath != nil)
    {
        NSURL* selectedURL = self.audioPathesArray[self.selectedIndexPath.row];
        [self.delegate pickAudioViewController:self didPickAudioAtURL:selectedURL];
    }
}

- (ANOggPlayer*)player
{
    if (_player == nil)
    {
        _player = [ANOggPlayer new];
        _player.delegate = self;
    }

    return _player;
}

#pragma mark - delegate

- (void)pickAudioCellDidPressPlay:(ANPickAudioCell*)cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    [self.player playFileAtURL:self.audioPathesArray[indexPath.row]];
}

#pragma mark - ANOggPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(ANOggPlayer*)player successfully:(BOOL)flag
{
    NSLog(@"audioPlayerDidFinishPlaying");
}

@end
