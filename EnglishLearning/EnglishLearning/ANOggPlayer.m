//
//  ANOggPlayer.m
//  Words Learning
//
//  Created by Andriy Zhuk on 3/12/16.
//  Copyright © 2016 azhuk. All rights reserved.
//

#import "ANOggPlayer.h"
#import "ANOggDecoder.h"

static NSInteger const ANBuffersCount = 3;

typedef enum ANAudioPlayStateTag
{
    ANAudioPlayerStateStopped,
    ANAudioPlayerStatePrepared,
    ANAudioPlayerStatePlaying,
    ANAudioPlayerStatePaused,
    ANAudioPlayerStateStopping

} ANAudioPlayerState;


@interface ANOggPlayer () {
    @private
    AudioQueueRef mQueue;
    AudioQueueBufferRef mBuffers[ANBuffersCount];
    BOOL mStopping;
    NSTimeInterval mQueueStartTime;
}

@property (nonatomic, strong) ANOggDecoder* decoder;

@property (nonatomic, assign) ANAudioPlayerState state;

@property (nonatomic) NSURL* oggFileUrl;

@end

@implementation ANOggPlayer

#pragma mark - static functions

static void ANOutputCallback(void* inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inCompleteAQBuffer)
{
    ANOggPlayer* pPlayer = (__bridge ANOggPlayer*)inUserData;
    [pPlayer readBuffer:inCompleteAQBuffer];
}

static void ANPropertyListener(void* inUserData, AudioQueueRef inAQ, AudioQueuePropertyID inID)
{
    ANOggPlayer* player = (__bridge ANOggPlayer*)inUserData;

    if (inID == kAudioQueueProperty_IsRunning)
    {
        BOOL isRunning = [player queryIsRunning] > 0;

        NSLog(@"isRunning = %u", isRunning);

        BOOL bDidFinish = (player.playing && !isRunning);

        player.playing = isRunning;

        if (bDidFinish)
        {
            [player.delegate audioPlayerDidFinishPlaying:player
             successfully:YES];
        }

        if (!isRunning)
        {
            player.state = ANAudioPlayerStateStopped;
            [player stop];
        }
    }
}

#pragma mark - fifecycle

- (void)dealloc
{
    AudioQueueDispose(mQueue, YES);
}

- (BOOL)playFileAtURL:(NSURL*)oggFileUrl
{
    if (self.isPlaying)
    {
        return NO;
    }

    self.oggFileUrl = oggFileUrl;
    [self play];

    return YES;
}

#pragma mark - public

- (void)setOggFileUrl:(NSURL*)oggFileUrl
{
    if (![_oggFileUrl isEqual:oggFileUrl])
    {
        _oggFileUrl = oggFileUrl;

        if (mQueue != NULL)
        {
            AudioQueueDispose(mQueue, true);
            mQueue = 0;
        }

        self.decoder.fileUrl = oggFileUrl;
        self.state = ANAudioPlayerStateStopped;

        AudioStreamBasicDescription dataFormat = self.decoder.dataFormat;

        OSStatus status = AudioQueueNewOutput(&dataFormat, ANOutputCallback, (__bridge void*)self, CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &mQueue);

        NSAssert(status == noErr, @"Audio queue creation was successful.");

        AudioQueueSetParameter(mQueue, kAudioQueueParam_Volume, 1.0);

        status = AudioQueueAddPropertyListener(mQueue, kAudioQueueProperty_IsRunning, ANPropertyListener, (__bridge void*)self);

        for (int i = 0; i < ANBuffersCount; ++i)
        {
            UInt32 bufferSize = 128 * 1024;
            status = AudioQueueAllocateBuffer(mQueue, bufferSize, &mBuffers[i]);

            if (status != noErr)
            {
                AudioQueueDispose(mQueue, true);
                mQueue = 0;
            }
        }
    }
    else
    {
        [self.decoder resetFile];
        self.state = ANAudioPlayerStateStopped;
        [self play];
    }
}

- (BOOL)prepareToPlay
{
    for (int i = 0; i < ANBuffersCount; ++i)
    {
        [self readBuffer:mBuffers[i]];
    }

    self.state = ANAudioPlayerStatePrepared;
    return YES;
}

- (BOOL)play
{
    switch (self.state)
    {
        case ANAudioPlayerStatePlaying:
            return NO;

        case ANAudioPlayerStatePaused:
        case ANAudioPlayerStatePrepared:
            break;

        default:
            [self prepareToPlay];
    }

    OSStatus osStatus = AudioQueueStart(mQueue, NULL);
    NSAssert(osStatus == noErr, @"AudioQueueStart failed");

    self.state = ANAudioPlayerStatePlaying;
    self.playing = YES;

    return (osStatus == noErr);
}

- (BOOL)stop
{
    return [self stop:YES];
}

- (BOOL)stop:(BOOL)immediate
{
    self.state = ANAudioPlayerStateStopping;
    OSStatus osStatus = AudioQueueStop(mQueue, immediate);

    NSAssert(osStatus == noErr, @"AudioQueueStop failed");
    return (osStatus == noErr);
}

#pragma mark - private

- (void)readBuffer:(AudioQueueBufferRef)buffer
{
    if (self.state == ANAudioPlayerStateStopping)
    {
        return;
    }

    NSAssert(self.decoder, @"self.decoder is valid.");

    if ([self.decoder readBuffer:buffer])
    {
        OSStatus status = AudioQueueEnqueueBuffer(mQueue, buffer, 0, 0);

        if (status != noErr)
        {
            NSLog(@"Error: %s status=%d", __PRETTY_FUNCTION__, (int)status);
        }
    }
    else
    {
        /*
         * Signal to the audio queue that we have run out of data,
         * but set the immediate flag to false so that playback of
         * currently enqueued buffers completes.
         */

        self.state = ANAudioPlayerStateStopping;
        Boolean immediate = false;

        AudioQueueStop(mQueue, immediate);
    }
}

#pragma mark - properties

- (UInt32)queryIsRunning
{
    UInt32 oRunning = 0;
    UInt32 ioSize = sizeof(oRunning);

    AudioQueueGetProperty(mQueue, kAudioQueueProperty_IsRunning, &oRunning, &ioSize);
    return oRunning;
}


- (ANOggDecoder*)decoder
{
    if (_decoder == nil)
    {
        _decoder = [[ANOggDecoder alloc] init];
    }

    return _decoder;
}


@end
