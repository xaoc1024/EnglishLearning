//
//  AppDelegate.m
//  EnglishLearning
//
//  Created by Andriy Zhuk on 11/21/15.
//  Copyright © 2015 azhuk. All rights reserved.
//

#import "AppDelegate.h"
#import "Model.h"
#import "HomeViewController.h"
#import "ANRequestsManager.h"
#import "ANWordAudioDataRequestManager.h"

@interface AppDelegate ()
@property (nonatomic, strong, readwrite) Model* model;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.model = [Model new];

    ANWordAudioDataRequestManager* manager = [ANWordAudioDataRequestManager new];
    [manager downloadWord:@"ubiquitous"];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.model saveContext];
}

@end
