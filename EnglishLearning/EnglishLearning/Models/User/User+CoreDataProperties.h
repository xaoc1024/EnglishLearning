//
//  User+CoreDataProperties.h
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/28/15.
//  Copyright © 2015 azhuk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString* identifier;
@property (nullable, nonatomic, retain) NSSet<Word *> *words;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addWordsObject:(Word *)value;
- (void)removeWordsObject:(Word *)value;
- (void)addWords:(NSSet<Word *> *)values;
- (void)removeWords:(NSSet<Word *> *)values;

@end

NS_ASSUME_NONNULL_END
