//
//  Word+CoreDataProperties.h
//  Words Learning
//
//  Created by Andriy Zhuk on 3/18/16.
//  Copyright © 2016 azhuk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Word.h"

NS_ASSUME_NONNULL_BEGIN

@interface Word (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *audioDownloadingCompleted;
@property (nullable, nonatomic, retain) NSString *audioFilePath;
@property (nullable, nonatomic, retain) NSNumber *correctAnswers;
@property (nullable, nonatomic, retain) NSDate *creationDate;
@property (nullable, nonatomic, retain) NSString *identifier;
@property (nullable, nonatomic, retain) NSString *originalWord;
@property (nullable, nonatomic, retain) NSNumber *totalAnswers;
@property (nullable, nonatomic, retain) NSString *transcription;
@property (nullable, nonatomic, retain) NSString *translation;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
