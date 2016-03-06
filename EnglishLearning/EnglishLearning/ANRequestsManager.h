//
//  ANHTTPClient.h
//  Words Learning
//
//  Created by Andriy Zhuk on 3/6/16.
//  Copyright © 2016 azhuk. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void(^ANRequestManagerCompletionBlock)(id resultObject, NSError* error);

@interface ANRequestsManager : NSObject

+ (instancetype)sharedRequestManager;

- (void)requestWordAudioFileNamesForWord:(NSString*)word withCompletionBlock:(ANRequestManagerCompletionBlock)completion;
- (void)requestAudioFileUrlsForFileNames:(NSArray*)fileNames withCompletionBlock:(ANRequestManagerCompletionBlock)completion;
- (void)downloadFilesAtURLs:(NSArray*)urlsArray withCompletionBlock:(ANRequestManagerCompletionBlock)completion;

@end
