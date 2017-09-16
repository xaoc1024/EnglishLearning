//
//  Model.m
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/21/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import "ANCoreDataManager.h"
#import "Word+CoreDataClass.h"
#import "User.h"
#import "Words-Swift.h"

static NSString* const kANFirstLaunch = @"kANFirstLaunch";

@interface ANCoreDataManager ()

@property (readonly, strong, nonatomic) NSManagedObjectModel* managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;

- (NSURL*)applicationDocumentsDirectory;

@end

@implementation ANCoreDataManager

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        [self createUser];
        [self setupModelIfNeeded];

    }
    return self;
}


+ (instancetype)sharedDataManager
{
    static ANCoreDataManager *sharedManager = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });

    return sharedManager;
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

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EnglishLearning" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"EnglishLearning.sqlite"];
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(YES), NSMigratePersistentStoresAutomaticallyOption, @(YES), NSInferMappingModelAutomaticallyOption, nil];

    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        NSString *failureReason = @"There was an error creating or loading the application's saved data.";

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

- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Work With Model

- (void)setupModelIfNeeded
{
    BOOL firstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:kANFirstLaunch];
    if (!firstLaunch)
    {
        [self setupModelWithWords];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kANFirstLaunch];
    }
}

- (void)setupModelWithWords
{
    NSError* error = nil;
    
    NSString *csvFileString = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"3000_Words" withExtension:@"csv"] encoding:NSUTF8StringEncoding  error:&error];

    NSArray *allLines = [csvFileString componentsSeparatedByString:@"\n"];

	if (allLines.count > 0)
	{
		WordsFileParser * wordsParser = [[WordsFileParser alloc] initWithManagedObjectContext:self.managedObjectContext];
		[wordsParser parseWordsRecords:allLines];
	}
}


@end
