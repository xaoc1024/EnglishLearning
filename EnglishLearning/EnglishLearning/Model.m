//
//  Model.m
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/21/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import "Model.h"
#import "Word.h"
#import "User.h"

@interface Model ()

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) User* user;

- (NSURL *)applicationDocumentsDirectory;

@end

@implementation Model

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        [self createUser];
    }
    return self;
}

- (void)createUser
{
    NSFetchRequest* userRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([User class])];
    NSError* error = nil;
    NSArray* fetchResult = [self.managedObjectContext executeFetchRequest:userRequest error:&error];
    
    if (error == nil)
    {
        if (fetchResult.count > 0)
        {
            self.user = fetchResult.lastObject;
        }
        else
        {
            self.user = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([User class]) inManagedObjectContext:self.managedObjectContext];
            self.user.identifier = [[NSUUID UUID] UUIDString];
            [self saveContext];
        }
    }
    else
    {
        NSLog(@"Error. Cannot find user. %@", error.userInfo);
        abort();
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.azhuk.EnglishLearning" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EnglishLearning" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"EnglishLearning.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Work With Model

- (void)setupModelWithWord
{
    NSError* error = nil;
    
    NSString *csvFileString= [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"EnglishWords" withExtension:@"csv"] encoding:NSUTF8StringEncoding  error:&error];
    
    NSArray *allLines = [csvFileString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    NSFetchRequest* wordsRequest = [NSFetchRequest fetchRequestWithEntityName:@"Word"];

    NSMutableSet* allWords = [NSMutableSet setWithArray:[self.managedObjectContext executeFetchRequest:wordsRequest error:&error]];
    
     for (NSString* line in allLines)
    {
        if (line.length == 0)
        {
            continue;
        }
        
        NSArray *elements = [line componentsSeparatedByString:@";"];
        
        NSString* originalWord = elements[1]; //original word
        
        __block Word* word = nil;
        if (originalWord.length > 0)
        {
            [allWords enumerateObjectsUsingBlock:^(id object, BOOL* stop) {
                Word* wordObject = object;
                
                if ([wordObject.originalWord isEqualToString:originalWord])
                {
                    word = wordObject;
                    *stop = YES;
                }
            }];
            
            if (word == nil)
            {
                word = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Word class]) inManagedObjectContext:self.managedObjectContext];
            }
            else
            {
                [allWords removeObject:word];
            }
            
            word.identifier = @([elements[0] integerValue]);
            
            word.originalWord = originalWord;
            
            word.trnascrption = elements[2];
            
            word.translatedWord = elements[3];
            
            word.user = self.user;
        }
    }
    
    [allWords enumerateObjectsUsingBlock:^(id object, BOOL* stop) {
        [self.managedObjectContext deleteObject:object];
    }];
    
    [self saveContext];
}


@end
