//
//  V24Tag.h
//  id3Tag
//
//  Created by Chris Drew on Thu Jan 16 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#ifdef __APPPLE__
#import <Foundation/Foundation.h>
#import "id3V2Frame.h"
#else
#ifndef _ID3FRAMEWORK_V24FRAMESET_H_
#define _ID3FRAMEWORK_V24FRAMESET_H_
#include <Foundation/NSObject.h>
#include "id3V2Frame.h"
@class NSMutableDictionary;
#endif
#endif

#define MAXUNCOMPRESSEDFRAMESIZE 10000000

@interface V24FrameSet : NSObject {
    //ID3 tag header variables
    int minorVersion;
    int tagLength;
    int frameOffset;
    
    int currentFramePosition;
    int currentFrameLength;
    int framesEndAt;
    int padding;
	
	BOOL iTunesFlag;
    
    //storage for tag
    NSMutableData *v2Tag;
    unsigned char *Buffer;
           
    //error variables
    int errorNo;
    NSString *errorDescription;
    
     //valid frames
    NSDictionary *validFrames;
	NSCharacterSet *validChars;
}
// information 
-(id)init:(NSMutableData *)Frames version:(int)Minor validFrameSet:(NSDictionary *)FrameSet frameSet:(NSMutableDictionary *)frameSet offset:(int)Offset iTunes:(BOOL)ITunes;
-(NSString *)getFrameID;
-(int)frameLength;
-(int)getFrameSetLength;

// read ID3 v2 header information
-(int)readPackedLengthFrom:(int)Offset;
- (int)readLargeByteLengthFrom:(int)Offset;

// id3V2 tag processing
-(id3V2Frame *)getFrame;
-(BOOL)nextFrame:(BOOL)atStart;
-(BOOL)atValidFrame;
-(BOOL)validFrameAt:(int)Offset;

-(void)dealloc;

@end