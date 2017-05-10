//
//  ANOggDecoder.h
//  Words Learning
//
//  Created by Andriy Zhuk on 3/12/16.
//  Copyright © 2016 azhuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <Vorbis/vorbisfile.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ANOggDecoder : NSObject

@property(nonatomic, readonly) AudioStreamBasicDescription dataFormat;
@property(nonatomic) NSURL* fileUrl;

- (BOOL)readBuffer:(AudioQueueBufferRef)pBuffer;

- (void)resetFile;

@end

