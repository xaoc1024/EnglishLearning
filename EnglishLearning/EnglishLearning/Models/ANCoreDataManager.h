//
//  Model.h
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/21/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObjectContext;
@class User;


@interface ANCoreDataManager : NSObject

+ (instancetype)sharedDataManager;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) User* user;

- (void)saveContext;
- (void)setupModelWithWords;

- (NSURL*)applicationDocumentsDirectory;

@end
