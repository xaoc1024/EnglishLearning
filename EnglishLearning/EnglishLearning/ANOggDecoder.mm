//
//  ANOggDecoder.m
//  Words Learning
//
//  Created by Andriy Zhuk on 3/12/16.
//  Copyright © 2016 azhuk. All rights reserved.
//

#import "ANOggDecoder.h"

static inline AudioFormatFlags    CalculateLPCMFlags2(UInt32 inValidBitsPerChannel, UInt32 inTotalBitsPerChannel, bool inIsFloat, bool inIsBigEndian, bool inIsNonInterleaved = false)
{
    return (inIsFloat ? kAudioFormatFlagIsFloat : kAudioFormatFlagIsSignedInteger) | (inIsBigEndian ? ((UInt32)kAudioFormatFlagIsBigEndian) : 0) | ((inValidBitsPerChannel == inTotalBitsPerChannel) ? kAudioFormatFlagIsPacked : kAudioFormatFlagIsAlignedHigh) | (inIsNonInterleaved ? ((UInt32)kAudioFormatFlagIsNonInterleaved) : 0);
}

inline void    FillOutASBDForLPCM2(AudioStreamBasicDescription& outASBD, Float64 inSampleRate, UInt32 inChannelsPerFrame, UInt32 inValidBitsPerChannel, UInt32 inTotalBitsPerChannel, bool inIsFloat, bool inIsBigEndian, bool inIsNonInterleaved = false)
{
    outASBD.mSampleRate = inSampleRate; outASBD.mFormatID = kAudioFormatLinearPCM; outASBD.mFormatFlags = CalculateLPCMFlags2(inValidBitsPerChannel, inTotalBitsPerChannel, inIsFloat, inIsBigEndian, inIsNonInterleaved); outASBD.mBytesPerPacket = (inIsNonInterleaved ? 1 : inChannelsPerFrame) * (inTotalBitsPerChannel / 8); outASBD.mFramesPerPacket = 1; outASBD.mBytesPerFrame = (inIsNonInterleaved ? 1 : inChannelsPerFrame) * (inTotalBitsPerChannel / 8); outASBD.mChannelsPerFrame = inChannelsPerFrame; outASBD.mBitsPerChannel = inValidBitsPerChannel;
}

@interface ANOggDecoder (){
    @private
    FILE* mpFile;
    OggVorbis_File mOggVorbisFile;
}

@property(nonatomic, readwrite) AudioStreamBasicDescription dataFormat;

@end

@implementation ANOggDecoder

- (void)setFileUrl:(NSURL*)fileUrl
{
    if (![_fileUrl isEqual:fileUrl])
    {
        _fileUrl = fileUrl;

        ov_clear(&mOggVorbisFile);
        if (mpFile)
        {
            fclose(mpFile);
            mpFile = NULL;
        }

        AudioStreamBasicDescription dataFormat;

        NSString* path = [fileUrl path];
        mpFile = fopen([path UTF8String], "r");
        NSAssert(mpFile, @"fopen succeeded.");

        int iReturn = ov_open_callbacks(mpFile, &mOggVorbisFile, NULL, 0, OV_CALLBACKS_NOCLOSE);
        NSAssert(iReturn >= 0, @"ov_open_callbacks succeeded.");
        vorbis_info* pInfo = ov_info(&mOggVorbisFile, -1);

        FillOutASBDForLPCM2(dataFormat, pInfo->rate, pInfo->channels, 16, 16, false, false);
        self.dataFormat = dataFormat;
    }
    else
    {
        [self resetFile];
    }
}

- (void)resetFile
{
    ov_pcm_seek(&mOggVorbisFile, 0.0);
}

- (void)dealloc
{
    ov_clear(&mOggVorbisFile);

    if (mpFile)
    {
        fclose(mpFile);
        mpFile = NULL;
    }
}

- (BOOL)readBuffer:(AudioQueueBufferRef)pBuffer
{
    BOOL bigEndian = 0;
    int wordSize = 2;
    int signedSamples = 1;
    int currentSection = -1;

    /* See: http://xiph.org/vorbis/doc/vorbisfile/ov_read.html */
    UInt32 nTotalBytesRead = 0;
    long nBytesRead = 0;

    do
    {
        nBytesRead = ov_read(&mOggVorbisFile, (char*)pBuffer->mAudioData + nTotalBytesRead, (int)(pBuffer->mAudioDataBytesCapacity - nTotalBytesRead), bigEndian, wordSize, signedSamples, &currentSection);

        if (nBytesRead  <= 0)
        {
            break;
        }

        nTotalBytesRead += nBytesRead;
    }
    while (nTotalBytesRead < pBuffer->mAudioDataBytesCapacity);

    if (nTotalBytesRead == 0)
    {
        return NO;
    }

    if (nBytesRead < 0)
    {
        return NO;
    }

    pBuffer->mAudioDataByteSize = nTotalBytesRead;
    pBuffer->mPacketDescriptionCount = 0;

    return YES;
}

@end
