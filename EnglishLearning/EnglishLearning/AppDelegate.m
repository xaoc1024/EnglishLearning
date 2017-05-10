//
//  AppDelegate.m
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/21/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import "AppDelegate.h"
#import "ANCoreDataManager.h"
#import "HomeViewController.h"
#import "ANRequestsManager.h"
#import "ANWordAudioManager.h"

@interface AppDelegate ()
@property (nonatomic, strong, readwrite) ANCoreDataManager* model;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    self.model = [ANCoreDataManager new];

    ANWordAudioManager* manager = [ANWordAudioManager new];
    [manager downloadWord:@"word" withCompletionBlock:^(id resultObject, NSError* error) {

    }];

    return YES;
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    [self.model saveContext];
}

@end
