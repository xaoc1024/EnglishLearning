//
//  Word+CoreDataProperties.m
//  Words Learning
//
//  Created by Andriy Zhuk on 3/18/16.
//  Copyright © 2016 azhuk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Word+CoreDataProperties.h"

@implementation Word (CoreDataProperties)

@dynamic audioDownloadingCompleted;
@dynamic audioFilePath;
@dynamic correctAnswers;
@dynamic creationDate;
@dynamic identifier;
@dynamic originalWord;
@dynamic totalAnswers;
@dynamic transcription;
@dynamic translation;
@dynamic user;

@end
