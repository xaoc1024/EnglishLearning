//
//  Word+CoreDataProperties.h
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/28/15.
//  Copyright © 2015 azhuk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Word.h"

@class User;

NS_ASSUME_NONNULL_BEGIN

@interface Word (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *identifier;
@property (nullable, nonatomic, retain) NSString *originalWord;
@property (nullable, nonatomic, retain) NSString *translatedWord;
@property (nullable, nonatomic, retain) NSString *trnascrption;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
