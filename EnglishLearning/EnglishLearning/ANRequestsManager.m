//
//  ANHTTPClient.m
//  Words Learning
//
//  Created by Andriy Zhuk on 3/6/16.
//  Copyright © 2016 azhuk. All rights reserved.
//

#import "ANRequestsManager.h"
#import "AFURLRequestSerialization.h"

static NSString* const _Nonnull kANWiktionaryBaseURLPath = @"https://en.wiktionary.org/w/api.php";
static NSString* const _Nonnull kANCommonsBaseURLPath = @"https://commons.wikimedia.org/w/api.php";

@interface ANRequestsManager ()
@property (nonatomic) AFHTTPSessionManager* wiktionaryManager;
@property (nonatomic) AFHTTPSessionManager* commonsManager;

@property (nonatomic) NSMutableArray* downloadTasks;
@property (nonatomic) NSURL* audiosURL;

@end

@implementation ANRequestsManager

+ (instancetype)sharedRequestManager
{
    static ANRequestsManager *sharedClient = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });

    return sharedClient;
}

- (instancetype)init
{
    self = [super init];

    if (self != nil)
    {
        _wiktionaryManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kANWiktionaryBaseURLPath]];
        _wiktionaryManager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];

        _commonsManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kANCommonsBaseURLPath]];
        _commonsManager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    }

    return self;
}

- (void)requestWordAudioFileNamesForWord:(NSString*)word withCompletionBlock:(ANRequestManagerCompletionBlock)completion
{
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    SAFE_SET_OBJECT(parameters, @"action", @"query");
    SAFE_SET_OBJECT(parameters, @"format", @"json");
    SAFE_SET_OBJECT(parameters, @"titles", word);
    SAFE_SET_OBJECT(parameters, @"prop", @"images");
    SAFE_SET_OBJECT(parameters, @"imlimit", @"100");

    [self.wiktionaryManager GET:@"" parameters:parameters progress:nil success:^(NSURLSessionDataTask* task, id responseObject) {
        NSLog(@"%@", responseObject);
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask* task, NSError* error) {
        NSLog(@"Error: %@", error);
        completion(nil, error);
    }];
}

- (void)requestAudioFileUrlsForFileNames:(NSArray*)fileNames withCompletionBlock:(ANRequestManagerCompletionBlock)completion
{
    NSString* allFileNames = [fileNames componentsJoinedByString:@"|"];
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    SAFE_SET_OBJECT(parameters, @"action", @"query");
    SAFE_SET_OBJECT(parameters, @"format", @"json");
    SAFE_SET_OBJECT(parameters, @"titles", allFileNames);
    SAFE_SET_OBJECT(parameters, @"prop", @"imageinfo");
    SAFE_SET_OBJECT(parameters, @"iiprop", @"url|mediatype");

    [self.commonsManager GET:@"" parameters:parameters progress:nil success:^(NSURLSessionDataTask* task, id responseObject) {
        NSLog(@"%@", responseObject);
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask* task, NSError* error) {
        NSLog(@"Error: %@", error);
        completion(nil, error);
    }];
}

- (void)downloadFilesAtURLs:(NSArray*)urlsArray withCompletionBlock:(ANRequestManagerCompletionBlock)completion
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    for (NSString* urlPath in urlsArray)
    {
        NSURL *URL = [NSURL URLWithString:urlPath];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];

        __block NSURLSessionDownloadTask *downloadTask = nil;

        downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            return [self.audiosURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            if (error != nil)
            {
                NSLog(@"Error: %@", error);
            }
            
            NSLog(@"File downloaded to: %@", filePath);
            [self.downloadTasks removeObject:downloadTask];
            completion(filePath, error);
        }];

        [downloadTask resume];

        [self.downloadTasks addObject:downloadTask];
    }
}

#pragma mark - getters

- (NSMutableArray*)downloadTasks
{
    if (_downloadTasks == nil)
    {
        _downloadTasks = [NSMutableArray new];
    }
    return _downloadTasks;
}

- (NSURL*)audiosURL
{
    if (_audiosURL == nil)
    {
        NSError* error = nil;

        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:&error];

        if (error != nil)
        {
            NSLog(@"downloadFilesAtURLs error: %@", error);
        }

        documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:@"Audios"];

        BOOL isDirectory = NO;

        if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectoryURL.absoluteString isDirectory:&isDirectory])
        {
            NSError* error = nil;
            [[NSFileManager defaultManager] createDirectoryAtURL:documentsDirectoryURL withIntermediateDirectories:YES attributes:nil error:&error];
            if (error != nil)
            {
                NSLog(@"Error: %@", error);
            }
        }

        _audiosURL = documentsDirectoryURL;
    }

    return _audiosURL;
}

@end