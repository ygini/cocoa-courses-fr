//
//  MP3Header.m
//  ID3
//
//  Created by Chris Drew on Tue Jul 22 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#ifdef __APPLE__
#import "MP3Header.h"
#import "md5.h"
#else
#include "MP3Header.h"
#include "md5.h"

#include <Foundation/NSData.h>
#include <Foundation/NSFileHandle.h>
#include <Foundation/NSString.h>
#include <Foundation/NSValue.h>

#endif

#define LENGTHBUFFER 4*2048
#define HASHSIZE 3*2048


@implementation MP3Header
- (id)init
{
    if (!(self = [super init])) return self;
    buffer = NULL;
    hash = NULL;
    startFrame = 0;
    bufferOffsetInFile = 0;
    XINGHeaderFound = NO;
    numberOfFrames = 0;
    seconds = 0;
    return self;
}

- (void)releaseAttributes
{
    if (buffer != NULL) [buffer release];
    if (hash != NULL) [hash release];
    buffer = NULL;
    hash = NULL;
    startFrame = 0;
    bufferOffsetInFile = 0;
    XINGHeaderFound = NO;
    numberOfFrames = 0;
    seconds = 0;
}

- (BOOL)openFile:(NSString *)File withTag:(int)EndOfTagInFile
{
    BOOL headerFound = NO;
    [self releaseAttributes];
    startFrame = EndOfTagInFile;
    bufferOffsetInFile = EndOfTagInFile;
    
    // open the file handle for the specified path
    NSFileHandle * file = [NSFileHandle fileHandleForReadingAtPath:File];
    if (file == NULL)
    {
        NSLog(@"Can not open file :%s",[File cString]);
        return NO;
    }
    
    // checks that MPEG file is long enough to process.  I assume that you always want to do the hash so the file need to be long enough to get sufficient data for the hash.  Currently the hash requires ~ 3*2048 Buffer is actually 4 * 2048 this leaves some space for the search (don't have to reload the buffer to hash if part the way through the buffer) and takes the buffer to whole number of cluster sizes.  So reading should be about the same speed as 3*2048.
    
    fileSize = [file seekToEndOfFile];
    if (fileSize < EndOfTagInFile + 2*LENGTHBUFFER)
    {
        NSLog(@"MP3 header processor file %s to short to process \n\r",[File cString]);
        [file closeFile];
        return NO;
    }
    
    // get block of data after the tag in the file
    [file seekToFileOffset:EndOfTagInFile];
    buffer = [[file readDataOfLength:LENGTHBUFFER] retain];
    if (buffer == NULL) 
    {
        NSLog(@"MP3 header processor could not load data from file %s\n\r",[File cString]);
        [file closeFile];
        return NO;
    }
    
    if (!(headerFound = [self findHeader]))
    {  // if findHeader can find a header load the buffer with another chunck of data and see if we are luck a second time
        [buffer release];
        [file seekToFileOffset:EndOfTagInFile+LENGTHBUFFER-1];
        startFrame += LENGTHBUFFER-1;
        bufferOffsetInFile += LENGTHBUFFER-1;
        buffer = [[file readDataOfLength:LENGTHBUFFER] retain];
        if (buffer == NULL) 
        {
            NSLog(@"MP3 header processor could not load data from file %s\n\r",[File cString]);
            [file closeFile];
            return NO;
        }
        
        if (!(headerFound = [self findHeader]))
        {  // If you can't find a valid header a second time give it up
            NSLog(@"MP3 header processor could not find a valid MPEG header in frame on two seperate tries, file name: %s\n\r",[File cString]);
            [file closeFile];
            [buffer release];
	    buffer = NULL;
            return NO;
        }
    }
    
    // process header
    [self decodeHeader];
    
    if (LENGTHBUFFER <  startFrame - bufferOffsetInFile + HASHSIZE) 
    {
        [buffer release];
        buffer = NULL;
        [file seekToFileOffset:startFrame];
        bufferOffsetInFile = startFrame;
        buffer = [[file readDataOfLength:LENGTHBUFFER] retain];
    }
    
    [file closeFile];
    return YES;
}

-(BOOL)findHeader
{ // looks for a MPEG audio header in the file and sets the internal counter startFrame to its location in the file
    int i;
    unsigned char * charPtr = (unsigned char *) [buffer bytes];
    for (i = 0; i < LENGTHBUFFER - 1 ; i++)
    {	// looks for frame header which is two bytes 11111111 111????? 
        if ((charPtr[i] == 0xff)&&((charPtr[i+1] & 0xE0)))
        { // if is finds the two byes it sets the start frame position to the locaton of the frame within the file.  I should actually check that this is a valid frame by checking that the next frame exists.  I will do this in the future.
            startFrame += i;
            return YES;
        }
    }
    return NO;
}

-(int) fileSize
{
    return fileSize;
}

-(BOOL)decodeHeader
{
/*	4th and 5th bit second byte 
        MPEG Audio version ID
           00 (0) - MPEG Version 2.5 (unofficial)
           01 (8) - reserved
           10 (10) - MPEG Version 2 (ISO/IEC 13818-3)
           11 (18) - MPEG Version 1 (ISO/IEC 11172-3)
*/
    unsigned char * charPtr = (unsigned char *) [buffer bytes];
    charPtr += startFrame - bufferOffsetInFile;

    int mpegCoding[] = { MPEG25, RESERVED, MPEG2, MPEG1 };    
    version = mpegCoding[(charPtr[1] & 0x18) >> 3];
    
/*	Layer description
           00 (0) - reserved
           01 (8) - Layer III
           10 (10) - Layer II
           11 (11) - Layer I
*/
    int layerCoding[] = { RESERVED, LAYERIII, LAYERII, LAYERI };
    layer = layerCoding[(charPtr[1] & 0x06) >> 1];

    const int bitRatesMPEG1[3][16] = 
    {	// MPEG 1
        {0, 32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, -1},
        {0, 32, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 384, -1},
        {0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, -1}
    };
    const int bitRatesMPEG2[3][16] =
    {	// MPEG2 & 2.5
        {0, 32, 48, 56, 64, 80, 96, 112, 128, 144, 160, 176, 192, 224, 256, -1},
        {0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160, -1},
        {0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160, -1}
    };
        
    int bitRateCode = (charPtr[2] >> 4);
    if ((version == RESERVED)||(layer == RESERVED)) bitRate = 0;
    else 
    {
        if (version == MPEG1) bitRate = bitRatesMPEG1[layer-1][bitRateCode];
        else bitRate = bitRatesMPEG2[layer-1][bitRateCode];
    }
    
// frequency decode tables 
    
    const int frequencyTables[3][4] =
    { // MPEG1, MPEG2, MPEG3
        { 44100, 48000, 32000, RESERVED},
        { 22050, 24000, 16000, RESERVED},
        { 11025, 12000, 8000, RESERVED}
    };
    
    if (version == RESERVED) frequency = RESERVED;
    else frequency = frequencyTables[version-1][(charPtr[2] >>2)&3];
    
/*        Channel Mode
           00 - Stereo
           01 - Joint stereo (Stereo)
           10 - Dual channel (2 mono channels)
           11 - Single channel (Mono)  */

    const int channelTable[] = { STEREO, JOINTSTEREO, DUALCHANNEL, SINGLECHANNEL};
    channels = channelTable[charPtr[3] && 3];
    
    if (bitRate > 0)
    {
        seconds = (fileSize - startFrame)*8/(bitRate*1000);
    }
    else seconds = 0;

    
    if (version == MPEG1)
    {
        if (channels == SINGLECHANNEL) charPtr += 21;
        else charPtr += 36;
    } else
    {
        if (channels == SINGLECHANNEL) charPtr += 14;
        else charPtr += 17;
    }
    
    if ((*charPtr == 'X')&&(charPtr[1] == 'i')&&(charPtr[2] == 'n')&&(charPtr[3] == 'g'))
    { // found XING header
        XINGHeaderFound = YES;
        if ((charPtr[7] & 1))
        {
            numberOfFrames = charPtr[8]*256*256*256 + charPtr[9]*256*256 + charPtr[10]*256 +charPtr[11];
            seconds = numberOfFrames * 26 /994;
            bitRate = (500+(fileSize - startFrame)*994*8/(numberOfFrames*26))/1000;
        }
    }
    return YES;
}

-(int) getSeconds
{
    return seconds;
}

-(NSString *) getSecondsString
{
    int days = 0;
    int hours = 0;
    int minutes = 0;
    int second = 0;
    int remainder = 0;

    days = seconds/(3600*24);
    remainder = seconds % (3600*24);
    
    hours = remainder/(3600);
    remainder = remainder % 3600;
    
    minutes = remainder/60;
    second = remainder % 60;
    
    if (days)
    {
	return [NSMutableString stringWithFormat:@"%i:%i:%i:%02i",days,hours,minutes,second];
    }
    
    if (hours)
    {
	return [NSMutableString stringWithFormat:@"%i:%i:%02i",hours,minutes,second];
    }
    
    if (minutes)
    {
	return [NSMutableString stringWithFormat:@"%i:%02i",minutes,second];
    }
    
    return [NSMutableString stringWithFormat:@"%i",second];
}

-(int) getVersion
{
    return version;
}

-(NSString *) getVersionString
{
    switch (version)
    {
        case MPEG1:	return @"MPEG 1";
        case MPEG2:	return @"MPEG 2";
        case MPEG25:	return @"MPEG 2.5";
        case RESERVED:	return @"UNKNOWN";
    }
    return  @"UNKNOWN";
}
        
-(int) getLayer
{
    return layer;
}

-(NSString *) getLayerString
{
    switch (layer)
    {
        case LAYERI:	return @"Layer 1";
        case LAYERII:	return @"Layer 2";
        case LAYERIII:	return @"Layer 3";
        case RESERVED:	return @"UNKNOWN";
    }
    return @"UNKNOWN";
}

-(int) getBitRate
{
    return bitRate;
}

-(NSString *) getBitRateString
{
    return [NSString stringWithFormat:@"%i kbps",bitRate];
}

-(int) getFrequency
{
    return frequency; 
}

-(NSString *) getFrequencyString
{
    return [NSString stringWithFormat:@"%i,%i kHz", frequency/1000, frequency%1000];
}

-(int) getChannels
{
    return channels;
}

-(NSString *) getChannelString
{
    switch (channels)
    {
        case STEREO		:   return @"Stereo";
        case JOINTSTEREO	:   return @"Joined Stereo";
        case DUALCHANNEL	:   return @"Dual Channel";
        case SINGLECHANNEL	:   return @"Single Channel";
    }
    return @"UNKNOWN";
}

-(int) getNumberOfFrames
{
    return numberOfFrames;
}

-(BOOL) getXINGHeaderFound
{
    return XINGHeaderFound;
}

-(NSMutableString *) getEncodingString
{
    NSMutableString * tempString = [[NSMutableString alloc] initWithCapacity:40];
    
    switch (version)
    {
        case MPEG1:	[tempString appendString:@"MPEG 1, "];
                        break;
        case MPEG2:	[tempString appendString:@"MPEG 2, "];
                        break;
        case MPEG25:	[tempString appendString:@"MPEG 2.5, "];
                        break;
        case RESERVED:	[tempString appendString:@"UNKNOWN, "];
                        break;
    }
    
    switch (layer)
    {
        case LAYERI:	[tempString appendString:@"Layer 1, "];
                        break;
        case LAYERII:	[tempString appendString:@"Layer 2, "];
                        break;
        case LAYERIII:	[tempString appendString:@"Layer 3, "];
                        break;
        case RESERVED:	[tempString appendString:@"UNKNOWN, "];
                        break;
    }
    
    [tempString appendString:[[NSNumber numberWithInt:bitRate] stringValue]];
    [tempString appendString:@"bps, "];
    [tempString appendString:[[NSNumber numberWithInt:frequency] stringValue]];
    [tempString appendString:@"Hz, "];
    
    switch (channels)
    {
        case STEREO		:	[tempString appendString:@"Stereo."];
                        break;
        case JOINTSTEREO	:	[tempString appendString:@"Joined Stereo."];
                        break;
        case DUALCHANNEL	:	[tempString appendString:@"Dual Channel."];
                        break;
        case SINGLECHANNEL	:	[tempString appendString:@"Single Channel."];
                        break;
    }
    
    [tempString autorelease];
    return tempString;
}


-(NSData *)hash
{
    md5_state_t state;
    md5_byte_t digest[16];
    unsigned char * tempPtr = (unsigned char *) [buffer bytes];
    tempPtr += startFrame - bufferOffsetInFile;

    md5_init(&state);
    md5_append(&state, (const md5_byte_t *)tempPtr, HASHSIZE);
    md5_finish(&state, digest);
    return [[NSData dataWithBytes: (unsigned char *) digest length:16] retain];
}

-(NSData *) getHash
{
    
    if (startFrame - bufferOffsetInFile + HASHSIZE > [buffer length]) return NULL;
    
    if ((hash == NULL)&&(buffer != NULL)) hash = [self hash];
    return hash;
}

-(void)dealloc
{
    if (buffer != NULL) [buffer release];
    if (hash != NULL) [hash release];
    buffer = NULL;
    hash = NULL;
    [super dealloc];
}
@end
