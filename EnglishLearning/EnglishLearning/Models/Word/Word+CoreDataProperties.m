//
//  Word+CoreDataProperties.m
//  Words Learning
//
//  Created by Andriy Zhuk on 2/28/16.
//  Copyright © 2016 azhuk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Word+CoreDataProperties.h"

@implementation Word (CoreDataProperties)

@dynamic identifier;
@dynamic originalWord;
@dynamic translatedWord;
@dynamic trnascrption;
@dynamic creationDate;
@dynamic totalAnswers;
@dynamic correctAnswers;
@dynamic user;

@end
