//
//  ANOggPlayer.h
//  Words Learning
//
//  Created by Andriy Zhuk on 3/12/16.
//  Copyright © 2016 azhuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ANOggPlayer;

@protocol ANOggPlayerDelegate <NSObject>

- (void)audioPlayerDidFinishPlaying:(ANOggPlayer*)player successfully:(BOOL)flag;

@end

@interface ANOggPlayer : NSObject

- (BOOL)playFileAtURL:(NSURL*)oggFileUrl;

@property(getter=isPlaying) BOOL playing;
/**
 * @brief Number of channels in the audio source.
 */
@property(readonly) NSUInteger numberOfChannels;
/**
 * @brief Duration of the source in seconds.
 */
@property(readonly) NSTimeInterval duration;
/**
 * @brief Delegate for notifications.
 */
@property(weak) id delegate;

@end
