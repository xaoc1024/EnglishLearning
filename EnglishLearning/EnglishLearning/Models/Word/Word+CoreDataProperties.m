//
//  Word+CoreDataProperties.m
//  Words
//
//  Created by Andriy Zhuk on 9/6/17.
//  Copyright © 2017 azhuk. All rights reserved.
//
//

#import "Word+CoreDataProperties.h"

@implementation Word (CoreDataProperties)

+ (NSFetchRequest<Word *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Word"];
}

@dynamic correctAnswers;
@dynamic creationDate;
@dynamic identifier;
@dynamic originalWord;
@dynamic totalAnswers;
@dynamic transcription;
@dynamic translation;
@dynamic user;

@end
