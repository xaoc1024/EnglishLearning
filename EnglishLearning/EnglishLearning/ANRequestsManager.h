//
//  ANHTTPClient.h
//  Words Learning
//
//  Created by Andriy Zhuk on 3/6/16.
//  Copyright © 2016 azhuk. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void(^ANCompletionBlock)(id resultObject, NSError* error);

@interface ANRequestsManager : NSObject

+ (instancetype)sharedRequestManager;

- (void)requestAudioFileNamesForWord:(NSString*)word withCompletionBlock:(ANCompletionBlock)completion;
- (void)requestAudioFileUrlsForFileNames:(NSArray*)fileNames withCompletionBlock:(ANCompletionBlock)completion;
- (void)downloadFilesAtURLs:(NSArray*)urlsArray withCompletionBlock:(ANCompletionBlock)completion;

@end
