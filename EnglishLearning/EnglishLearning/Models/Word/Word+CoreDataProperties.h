//
//  Word+CoreDataProperties.h
//  Words Learning
//
//  Created by Andriy Zhuk on 2/28/16.
//  Copyright © 2016 azhuk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Word.h"

NS_ASSUME_NONNULL_BEGIN

@interface Word (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *identifier;
@property (nullable, nonatomic, retain) NSString *originalWord;
@property (nullable, nonatomic, retain) NSString *translatedWord;
@property (nullable, nonatomic, retain) NSString *trnascrption;
@property (nullable, nonatomic, retain) NSDate *creationDate;
@property (nullable, nonatomic, retain) NSNumber *totalAnswers;
@property (nullable, nonatomic, retain) NSNumber *correctAnswers;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
