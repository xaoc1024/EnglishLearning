//
//  ANWordAudioManager.h
//  Words Learning
//
//  Created by Andriy Zhuk on 3/6/16.
//  Copyright © 2016 azhuk. All rights reserved.
//

#import "ANWordAudioManager.h"
#import "ANRequestsManager.h"

@interface ANWordAudioManager ()
@property (nonatomic) ANRequestsManager* requestManager;
@end

@implementation ANWordAudioManager

- (ANRequestsManager*)requestManager
{
    return [ANRequestsManager sharedRequestManager];
}

- (void)downloadWord:(NSString*)word withCompletionBlock:(ANCompletionBlock)completion
{
    NSString* preparedWord = [word stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    preparedWord = [preparedWord stringByReplacingOccurrencesOfString:@" " withString:@"_" options:0 range:NSMakeRange(0, preparedWord.length)];

    [self.requestManager requestAudioFileNamesForWord:preparedWord withCompletionBlock:^(id namesResultObject, NSError* error) {
        if (error == nil && [namesResultObject isKindOfClass:[NSDictionary class]])
        {
            NSArray* audioFileNames = [self fileNamesFromResponse:namesResultObject];
            [self.requestManager requestAudioFileUrlsForFileNames:audioFileNames withCompletionBlock:^(id urlsResultObject, NSError* error) {
                if (error == nil && [urlsResultObject isKindOfClass:[NSDictionary class]])
                {
                    NSArray* urlsArray = [self wordAudioUrlsFromResponse:urlsResultObject];
                    [self.requestManager downloadFilesAtURLs:urlsArray withCompletionBlock:^(id pathObject, NSError* error) {
                        if (completion != nil)
                        {
                            completion(pathObject, error);
                        }
                        NSLog(@"%@", pathObject);
                    }];
                }
                else
                {
                    completion(nil, error);
                }
            }];
        }
        else
        {
            completion(nil, error);
        }
    }];
}

- (NSArray*)fileNamesFromResponse:(NSDictionary*)responseResult
{
    NSMutableArray<NSString*>* audioFileNamesArray = [NSMutableArray new];
    [self enumeratePagesDictionaryFromResponse:responseResult usingBlock:^(id key, id obj) {
        NSArray* images = obj[@"images"];
        if (images.count > 0)
        {
            for (NSDictionary* imageEntry in images)
            {
                SAFE_ADD_OBJECT(audioFileNamesArray, SAFE_GET_OBJECT(imageEntry, @"title"));
            }
        }
    }];

    return [audioFileNamesArray copy];
}

- (NSArray*)wordAudioUrlsFromResponse:(NSDictionary*)response
{
    NSMutableArray* audioFilesArray = [NSMutableArray new];

    [self enumeratePagesDictionaryFromResponse:response usingBlock:^(id key, NSDictionary* obj) {
        NSArray* imageInfo = SAFE_GET_OBJECT(obj, @"imageinfo");

        [imageInfo enumerateObjectsUsingBlock:^(NSDictionary* mediaInfoObj, NSUInteger idx, BOOL* stop) {

            if ([[SAFE_GET_OBJECT(mediaInfoObj, @"mediatype") uppercaseString] isEqualToString:@"AUDIO"])
            {
                SAFE_ADD_OBJECT(audioFilesArray, SAFE_GET_OBJECT(mediaInfoObj, @"url"));
            }
        }];

    }];

    return [audioFilesArray copy];
}

- (void)enumeratePagesDictionaryFromResponse:(NSDictionary*)response usingBlock:(void (^)(id key, id obj))block
{
    NSDictionary* query = SAFE_GET_OBJECT(response, @"query");

    if (query.count > 0)
    {
        NSDictionary* pages = SAFE_GET_OBJECT(query, @"pages");
        [pages enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSDictionary* obj, BOOL* stop) {
            NSInteger pageID = [key integerValue];
            if (pageID > 0)
            {
                block(key, obj);
            }
        }];
    }
}

@end
