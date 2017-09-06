//
//  Word+CoreDataProperties.h
//  Words
//
//  Created by Andriy Zhuk on 9/6/17.
//  Copyright © 2017 azhuk. All rights reserved.
//
//

#import "Word+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Word (CoreDataProperties)

+ (NSFetchRequest<Word *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *correctAnswers;
@property (nullable, nonatomic, copy) NSDate *creationDate;
@property (nullable, nonatomic, copy) NSString *identifier;
@property (nullable, nonatomic, copy) NSString *originalWord;
@property (nullable, nonatomic, copy) NSNumber *totalAnswers;
@property (nullable, nonatomic, copy) NSString *transcription;
@property (nullable, nonatomic, copy) NSString *translation;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
