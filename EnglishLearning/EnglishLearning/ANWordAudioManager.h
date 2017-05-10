//
//  ANWordAudioManager.h
//  Words Learning
//
//  Created by Andriy Zhuk on 3/6/16.
//  Copyright © 2016 azhuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANWordAudioManager : NSObject

- (void)downloadWord:(NSString*)word withCompletionBlock:(ANCompletionBlock)completion;

@end
