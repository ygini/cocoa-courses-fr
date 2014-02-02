//
//  TagAPI.m
//  id3Tag
//
//  Created by Chris Drew on Tue Nov 12 2002.
//  Copyright (c) 2002 __MyCompanyName__. All rights reserved.
//
#ifdef __APPLE__
#import "TagAPI.h"
#else
#include "TagAPI.h"

#include <Foundation/NSArray.h>
#include <Foundation/NSBundle.h>
#include <Foundation/NSDictionary.h>
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSString.h>
#include <Foundation/NSValue.h>


#endif

@implementation TagAPI
-(void)releaseAttributes
{
    if (v2Tag != NULL) [v2Tag release];
    v2Tag = NULL;
    if (v1Tag != NULL) [v1Tag release];
    v1Tag = NULL;
    if (path != NULL) [path release];
    path = NULL;
    if (frameList != NULL) [frameList release];
    frameList = NULL;
    if (mp3Header != NULL) [mp3Header release];
    mp3Header = NULL;
}    

-(id)initWithGenreList:(NSMutableDictionary *)Dictionary
{
    if (!(self = [super init])) return self;
    
    dataDictionary = NULL;

    modify = NO;
    
    genreDictionary = NULL;
    externalDictionary = NO;
    
    parsedV1 = NO;
	parse = 0;
    v2Tag = NULL;
    v1Tag = NULL;
    mp3Header = NULL;
    path = NULL;
    frameList = NULL;
    fileSize = 0;
    
    //loads data dictionary containing frame and genre information
	NSString *dataPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"data" ofType:@"plist"];
	dataDictionary =  [[NSMutableDictionary alloc] initWithContentsOfFile:dataPath];
    
    if (dataDictionary == NULL) 
    {
        NSLog(@"Failed to open resource dictionary, can not find file:%s",[dataPath cString]);
        [self autorelease];
        return NULL;
    }
	    
    // loads a genre look up table into a dictionary
    if (Dictionary == NULL)
    {
        genreDictionary = [dataDictionary objectForKey:@"genres"];
        if (genreDictionary == NULL) 
        {
            [self autorelease];
            NSLog(@"Failed to find internal genres list");
            return NULL;
        }
        externalDictionary = NO;
    }
    else
    {
        genreDictionary = Dictionary;
        externalDictionary = YES;
    }
    
    // load preferences
    preferences = [dataDictionary objectForKey:@"preferences"];
    if (genreDictionary == NULL) 
    {
        [self autorelease];
        NSLog(@"Failed to load ID3 preferences");
        return NULL;
    }

    return self;
}

-(BOOL)examineFile:(NSString *)Path
{
    [self releaseAttributes];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    path = [Path copy];
    int position = 0;
	parse = 0;
    
    parsedV1 = NO;
      
    // looks for a v2 tag and saves it memory if found

    v2Tag = [[id3V2Tag alloc] initWithFrameDictionary:[dataDictionary objectForKey:@"frames"]];
    if (v2Tag == NULL)
    {
        NSLog(@"Failed to create V2 tag object");
        [pool release];
        return NO;
    }
	if ([[preferences objectForKey:@"iTunes v2.4 compatability mode"] boolValue]) [v2Tag setITunesCompatability:YES];
	
    [v2Tag openPath:path];
	// position indicate
    position = [v2Tag tagPositionInFile] + [v2Tag tagLength];
  
    // looks for a v1.1 tag and saves it to memory if found
    v1Tag = [[id3V1Tag alloc] init];
    if (v1Tag == NULL)
    {
        NSLog(@"Failed to create V1.1 tag object");
        [pool release];
        return NO;
    } 
    
    BOOL test = [[preferences objectForKey:@"Parse V1 only if V2 does not exist"] boolValue];
    if ([[preferences objectForKey:@"Parse V1"] boolValue]||(test&&![v2Tag tagPresent]))
    {
        parsedV1 = YES;
        [v1Tag openPath:path];   
        if (![v1Tag tagPresent]&&[[preferences objectForKey:@"Write V1 Always"] boolValue])
        {
            // if v2 tag exists copy data into v1 tag
            if ([v2Tag tagPresent]) [self copyV2TagToV1Tag];
            else [v1Tag newTag];
        }
    }
  
    // if there is no storage for a V2 tag create a v2 tag
    if (![v2Tag tagPresent])
    {
        if ([v1Tag tagPresent]) [self copyV1TagToV2Tag];
        else [v2Tag newTag:[[preferences objectForKey:@"Default V2 tag - Major number"] intValue] minor:[[preferences objectForKey:@"Default V2 tag - Minor number"] intValue]];
    }
  
    // get mpeg header information
    mp3Header = [[MP3Header alloc] init];
    if (mp3Header == NULL)
    {
        NSLog(@"Failed to create MP3 Header Object");
        [pool release];
        return NO;
    }
    
    [mp3Header openFile:path withTag:position];
    fileSize = [mp3Header fileSize];
//	[self convertTagToV2:0];
    [pool release];
    return YES;
}

-(id)initWithPath:(NSString *)Path genreDictionary:(NSMutableDictionary *)Dictionary
{
    if (![self initWithGenreList:Dictionary]) return NULL;
    [self examineFile:Path];
    return self;
}

-(int)getDuration
{
    return [mp3Header getSeconds];
}

-(int)getBitRate
{
    return [mp3Header getBitRate];
}

-(int)getFrequency
{
    return [mp3Header getFrequency];
}

-(NSMutableString *)getEncoding
{
    return [mp3Header getEncodingString];
}

-(NSString *)getDurationString
{
    return [mp3Header getSecondsString];
}

-(NSString *) getVersionString
{
    return [mp3Header getVersionString];
}

-(NSString *) getLayerString
{
    return [mp3Header getLayerString];
}

-(NSString *) getBitRateString
{
    return [mp3Header getBitRateString];
}

-(NSString *) getFrequencyString
{
    return [mp3Header getFrequencyString];
}

-(NSString *) getChannelString
{
    return [mp3Header getChannelString];
}


// get standard properties from Tag.
-(NSString *)getTitle
{
    NSString * title = @"";
    
    if (parse != 1)
    {
            if ([v2Tag tagPresent]==YES) 
            {
                title = [v2Tag getTitle];
				if (title != NULL) return title;
            }
            if ((parse == 2)||(![[preferences objectForKey:@"V1 auto - fallback"] boolValue])) return @"";
    }
    
    if (!parsedV1) if (![v1Tag openPath:path]) return @"";
    parsedV1 = YES;         
    if ([v1Tag tagPresent]==YES) return [v1Tag getTitle];
    return @"";
}

-(NSString *)getArtist
{
    NSString * artist = @"";
    
    if (parse != 1)
    {
            if ([v2Tag tagPresent]==YES) 
            {
                artist = [v2Tag getArtist];
				if (artist != NULL) return artist;
            }
            if ((parse == 2)||(![[preferences objectForKey:@"V1 auto - fallback"] boolValue])) return @"";
    }

    if (!parsedV1) if (![v1Tag openPath:path]) return @"";
    parsedV1 = YES;         
    if ([v1Tag tagPresent]==YES) return [v1Tag getArtist];
 
    return @"";
}

-(NSString *)getAlbum
{
    NSString * album = @"";
    
    if (parse != 1)
    {
            if ([v2Tag tagPresent]==YES) 
            {
                album = [v2Tag getAlbum];
				if (album != NULL) return album;
            }
            if ((parse == 2)||(![[preferences objectForKey:@"V1 auto - fallback"] boolValue])) return @"";
    }
    
    if (!parsedV1) if (![v1Tag openPath:path]) return @"";
    parsedV1 = YES;         
    if ([v1Tag tagPresent]==YES) return [v1Tag getAlbum];
    
    return @"";
}

-(int)getYear
{
    int year = 0;

    if (parse != 1)
    {
            if ([v2Tag tagPresent]==YES) 
            {
                year = [v2Tag getYear];
				if (year > -1)  return year;
            }
            if ((parse == 2)||(![[preferences objectForKey:@"V1 auto - fallback"] boolValue])) return 0;
    }
    
    if (!parsedV1) if (![v1Tag openPath:path]) return 0;
    parsedV1 = YES;         
    if ([v1Tag tagPresent]==YES) return [v1Tag getYear];
    return 0;
}

-(int)getTrack
{
    int track = 0;
    
    if (parse != 1)
    {
            if ([v2Tag tagPresent]==YES) 
            {
                track = [v2Tag getTrack];
				if (track > -1) return track;
            }
            if ((parse == 2)||(![[preferences objectForKey:@"V1 auto - fallback"] boolValue])) return 0;
    }
    
    if (!parsedV1) if (![v1Tag openPath:path]) return 0;
    parsedV1 = YES;         
    if ([v1Tag tagPresent]==YES) return [v1Tag getTrack];
    return 0;
}

-(int)getTotalNumberTracks
{
    int track = 0;
    
    if (parse != 1)
    {
            if ([v2Tag tagPresent]==YES) 
            {
                return [v2Tag getTotalNumberTracks];
            }
    }
    return track;
}

-(int)getDisk
{
    int track = 0;
    
    if (parse != 1)
    {
            if ([v2Tag tagPresent]==YES) 
            {
                return [v2Tag getDisk];
            }
    }
    
    return track;
}

-(int)getTotalNumberDisks
{
    int track = 0;
    
    if (parse != 1)
    {
            if ([v2Tag tagPresent]==YES) 
            {
                return [v2Tag getTotalNumberDisks];
            }
    }
    return track;
}

-(NSArray *)getGenreNames
{
    NSArray * genreName = NULL;
    
    if (parse != 1) // ie parse v2 tag unless parse is set to 1 to ensure that v1 tag is parsed
    {
            if ([v2Tag tagPresent]==YES) 
            {
                genreName = [v2Tag getGenreNames];
                
                if ((genreName == NULL)||([genreName count] == 0)) return NULL;    
                return [self processGenreArray:genreName];
            }
            if ((parse == 2)||(![[preferences objectForKey:@"V1 auto - fallback"] boolValue])) return NULL;  // if only parse v2 tag is set return null as no tag is present
    }
    
    if (!parsedV1) if (![v1Tag openPath:path]) return NULL;
    parsedV1 = YES;         
    if ([v1Tag tagPresent]==YES)
    {
            genreName = [NSArray arrayWithObject:[[dataDictionary objectForKey:@"genreIndexes"] objectForKey:[[NSNumber numberWithInt:[v1Tag getGenre]] stringValue]]];
            if (genreName == NULL) genreName = [NSArray arrayWithObject:@"Unknown"];
            return genreName;
    }
    return genreName;
}

-(NSString *)getComments
{
    NSString * comments = @"";
    
    if (parse != 1)
    {
            if ([v2Tag tagPresent]==YES) {
                comments = [v2Tag getComments];
				if (comments != NULL) return comments;
            }
            if ((parse == 2)||(![[preferences objectForKey:@"V1 auto - fallback"] boolValue])) return @"";
    }
    
    if (!parsedV1) if (![v1Tag openPath:path]) return @"";
    parsedV1 = YES;         
    if ([v1Tag tagPresent]==YES) return [v1Tag getComment];

    return @"";
}

-(NSMutableArray *)getImage
{
    if ((![v2Tag tagPresent])||(parse == 1)) return NULL;
    
    return [v2Tag getImage];
}

-(NSString *)getComposer
{
    if ((![v2Tag tagPresent])||(parse == 1)) return @"";
    return [v2Tag getComposer];
}

- (NSArray *) getContentForFrameID:(NSString *)ID {
	return [v2Tag getContentForFrameID:ID];
}


- (BOOL) convertTagToV2:(int)minorVersion {
	// check there is a v2 tag to copy information from
	BOOL result = YES; 
    
	id3V2Tag * newTag = [[id3V2Tag alloc] initWithFrameDictionary:[dataDictionary objectForKey:@"frames"]];
	[newTag newTag:2 minor:minorVersion];
	[newTag setPath:path];
	
	if (![self v2TagPresent])
    {
		NSArray * frameID = [self getFrameList];
		int i,y;
		y = [frameID count];
		for (i = 0; i < y; i++) {
			if (![newTag setContent:[self getContentForFrameID:[frameID objectAtIndex:i]] forFrame:[frameID objectAtIndex:i] replace:YES ]) result = NO;
		}

		if (![newTag setDisk:[self getDisk] totalDisks:[self getTotalNumberDisks]]) result = NO;
		if (![newTag setImages:[self getImage]]) result = NO;
	}
    if (![newTag setTitle:[self getTitle]]) result = NO;
    if (![newTag setArtist:[self getArtist]]) result = NO;
    if (![newTag setAlbum:[self getAlbum]]) result = NO;
    if (![newTag setYear:[self getYear]]) result = NO;
    if (![newTag setTrack:[self getTrack] totalTracks:[self getTotalNumberTracks]]) result = NO;
	if (![newTag setGenreName:[self getGenreNames]]) result = NO;
    if (![newTag setComments:[self getComments]]) result = NO;
	
	[v2Tag dropTag:NO];
	[v2Tag release];
	v2Tag = newTag;
	[newTag writeTag];
	
    return result;
}


-(NSMutableArray *)getFrame:(NSString *)Title
{
    id anObject = [v2Tag getFramesTitled:Title];
    if (anObject == NULL) return NULL;
    
    if ([anObject isKindOfClass:[NSMutableArray class]]) return anObject;
    else
 	return [NSMutableArray arrayWithObject:anObject];
  
    return NULL;
}

-(NSDictionary *)getFrameDescription:(NSString *)FrameID
{
    switch ([self v2TagVersion])
    {
	case 0:    return [[[dataDictionary objectForKey:@"frames"] objectForKey:@"2.0"] objectForKey:FrameID];
	case 1:    return [[[dataDictionary objectForKey:@"frames"] objectForKey:@"2.0"] objectForKey:FrameID];
	case 2:    return [[[dataDictionary objectForKey:@"frames"] objectForKey:@"2.0"] objectForKey:FrameID];
	case 3:    return [[[dataDictionary objectForKey:@"frames"] objectForKey:@"2.3"] objectForKey:FrameID];
	case 4:    return [[[dataDictionary objectForKey:@"frames"] objectForKey:@"2.4"] objectForKey:FrameID];
    }
    return NULL;
}

-(NSString *)getPath
{
    return path;
}

-(id3V1Tag *)getV1Tag
{  // will provide a transparent method and remove access to the direct class
    return v1Tag;
}

-(id3V2Tag *)getV2Tag
{  // will provide a transparent method and remove access to the direct class
    return v2Tag;
}

-(NSArray *)getGenreList
{
    return [[dataDictionary objectForKey:@"genres"] allKeys];
}

-(NSString *)getEncodedBy
{
    if ((![v2Tag tagPresent])||(parse == 1)) return NULL;
    
    return [v2Tag getEncodedBy];
}


//Sets information in V1 and V2 tag

-(BOOL)setTitle:(NSString *)Title
{
    BOOL result = YES;
    if (v2Tag != NULL)  if (result = [v2Tag setTitle:Title]) modify = YES;
    if (v1Tag != NULL) {
        if (!parsedV1) if (![v1Tag openPath:path]) return NO;
        parsedV1 = YES;
        if ([v1Tag setTitle:Title]) result = NO;
		else modify = YES;
    }   
    return result;
}

-(BOOL)setArtist:(NSString *)Artist
{
    BOOL result = YES;
    if (v2Tag != NULL) if (result = [v2Tag setArtist:Artist]) modify = YES;
    if (v1Tag != NULL) {
        if (!parsedV1) if (![v1Tag openPath:path]) return NO;
        parsedV1 = YES;
        if (![v1Tag setArtist:Artist]) return NO;
		else modify = YES;
    }    

    return result;
}

-(BOOL)setAlbum:(NSString *)Album {
    BOOL result = YES;
    if (v2Tag != NULL) if (result = [v2Tag setAlbum:Album]) modify = YES;
    if (v1Tag != NULL) {
        if (!parsedV1) if (![v1Tag openPath:path]) return NO;
        parsedV1 = YES;
        if (![v1Tag setAlbum:Album]) return NO;
		else modify = YES;
    }    
    return result;
}

-(BOOL)setYear:(int)Year {
    BOOL result = YES;
    if (v2Tag != NULL) result = [v2Tag setYear:Year];
    if (v1Tag != NULL) {
        if (!parsedV1) if (![v1Tag openPath:path]) return NO;
        parsedV1 = YES;
        if (![v1Tag setYear:Year]) return NO;
		else modify = YES;
    }    
    return result;
}

-(BOOL)setTrack:(int)Track totalTracks:(int)Total {
    BOOL result = YES;
    if (v2Tag != NULL) if (result = [v2Tag setTrack:Track totalTracks:Total]) modify = YES;
    if (v1Tag != NULL) {
        if (!parsedV1) if (![v1Tag openPath:path]) return NO;
        parsedV1 = YES;
        if (![v1Tag setTrack:Track]) return NO;
		else modify = YES;
    }    
    return result;
}

-(BOOL)setDisk:(int)Disk totalDisks:(int)Total {
    if (v2Tag != NULL) 
		if ([v2Tag setDisk:Disk totalDisks:Total]) modify = YES;
		else return NO;
	return YES;
}

-(BOOL)setGenreName:(NSArray *)GenreName {
    BOOL result = YES;
    
    if ([GenreName count] < 1) return NO;
    
    int sequenceNumber = [[[dataDictionary objectForKey:@"genreIndexes"] objectForKey:@"-1"] intValue];
    
    // check the genre names to ensure that they are in the dictionary
    if (externalDictionary) // only change it if you have an external genre dictionary
    {
		int i = [GenreName count];
		for (i --; i >= 0 ; i--) {
			NSString * tempString = [GenreName objectAtIndex:i];
			id anObject = [genreDictionary objectForKey:tempString];
            if (anObject == NULL)  {//If the genre does not exist in the dictionary and the Dictionary is not the static one provided with the library then add the new genre.
                sequenceNumber++;
                [[dataDictionary objectForKey:@"genreIndexes"] setObject:[NSNumber numberWithInt:sequenceNumber] forKey:@"-1"];
                [genreDictionary setObject:[NSNumber numberWithInt:sequenceNumber] forKey:anObject];
             }
		}
    }
    
    if (v2Tag != NULL) if (result = [v2Tag setGenreName:GenreName]) modify = YES;
	if (v1Tag != NULL) {
        if (!parsedV1) if (![v1Tag openPath:path]) return NO;
        parsedV1 = YES;
        id tempNumber = [genreDictionary objectForKey:[GenreName objectAtIndex:0]];
        
        if ([tempNumber isMemberOfClass:[NSNumber class]])
        {
            int temp = [tempNumber intValue];
            if (temp <= MAX_INDEX_DEFINED_GENRES){ if (![v1Tag setGenre:temp]) return NO;}
            else if (![v1Tag setGenre:0]) return NO;
				else modify = YES;
        }
    }    
    return result;
}

-(BOOL)setComments:(NSString *)Comments {
    BOOL results = YES;
    
    if (v2Tag != NULL) if (results = [v2Tag setComments:Comments]) modify = YES;
    if (v1Tag != NULL) {
        if (!parsedV1) if (![v1Tag openPath:path]) return NO;
        parsedV1 = YES;
        if (![v1Tag setComment:Comments]) return NO;
		else modify = YES;
    }    
    return results;
}

-(BOOL)setImages:(NSMutableArray *)Images {
    BOOL results = NO;
	if (Images == NULL) return NO;
    if (v2Tag != NULL) if (results = [v2Tag setImages:Images]) modify = YES; 
    return results;
}

-(BOOL)setFrame:(id3V2Frame *)newFrame replace:(BOOL)Replace {
    if (v2Tag == NULL) return NO;
    BOOL result = [v2Tag addUpdateFrame:newFrame replace:Replace frame:0];
    
    modify = modify || result;
    return result;
}

-(BOOL)setFrames:(NSMutableArray *)newFrames {
    BOOL result;
	if (v2Tag == NULL) return NO;
	if (result = [v2Tag setFrames:newFrames]) modify = YES;
	return result;
}

-(BOOL)setEncodedBy:(NSString *)Text {
    BOOL results = YES;
    if (Text == NULL) return NO;
    if (v2Tag != NULL) if (results = [v2Tag setEncodedBy:Text]) modify = YES;
    return results;
}

-(BOOL)setComposer:(NSString *)Text {
    BOOL results = YES;
    if (Text == NULL) return NO;
    if (v2Tag != NULL) if (results = [v2Tag setComposer:Text]) modify = YES;
    return results;
}

-(BOOL)setContent:(NSArray *)Content  forFrame:(NSString *)IDAlias {
	return [v2Tag setContent:Content forFrame:IDAlias replace:YES];
}

// tag 

-(BOOL)v1TagPresent
{
    if (!parsedV1) if (![v1Tag openPath:path]) return NO;
    parsedV1 = YES;
    return [v1Tag tagPresent];
}

-(BOOL)v2TagPresent
{
    return [v2Tag tagPresent];
}

-(int)v2TagVersion
{
    if ([v2Tag tagPresent])
        return [v2Tag tagVersion];
    return 0;
}

-(BOOL)dropFrame:(id3V2Frame *)Frame {
	if ([v2Tag tagPresent])
		if ([v2Tag dropFrame:Frame] == YES) {
			modify = YES;
			return YES;
		};
	return NO;
}

-(int)updateFile
{
    int returnValue = 0;
    if(modify)
    {
        if ([[preferences objectForKey:@"Write V1 Always"] boolValue]||[v1Tag tagPresent]) 
        {
            if (![v1Tag tagPresent]) [self copyV2TagToV1Tag];
            if (![v1Tag writeTag]) returnValue = -2;
        }

        if ([v2Tag tagPresent]|| [[preferences objectForKey:@"Write V2 Always"] boolValue])
        {
            if (![v2Tag writeTag]) returnValue += -1;
        }
        
        // check to ensure that a v2 tag has been written before wiping the v1 tag
        // if a v2 tag has not been written correctly the lib will not wipe the V1 tag
        // if "always write V1" is set you can not drop a V1 frame
        if ([[preferences objectForKey:@"Drop V1"] boolValue]&&[[preferences objectForKey:@"Write V2 Always"] boolValue]&&!returnValue&&![[preferences objectForKey:@"Write V1 Always"] boolValue]) [v1Tag dropTag];
    }
    return returnValue;
}

-(NSArray *)getFrameList
{
    if ((frameList!=NULL)&&(!modify)) return frameList;
    
    return [v2Tag frameList];    
}

-(long int)getFileSize
{
    return fileSize;
}

-(int)getPaddingLength
{
    return [v2Tag getPaddingLength];
}


-(int)getTagLength
{
    return [v2Tag tagLength];
}

-(NSData *)getHash
{
    return [mp3Header getHash];
}

-(BOOL)copyV2TagToV1Tag
{
    BOOL result = YES;
    
    // check there is a v2 tag to copy information from
    if (![self v2TagPresent])
    {
        NSLog(@"copyV2TagToV1Tag: No v2 tag present to copy");
        return NO;
    }
    
    // check that v1 tag object exists and file was parsed and create a tag if it doesn't
    if ((!parsedV1)||(v1Tag == NULL))
    {
        if (v1Tag == NULL) v1Tag = [[id3V1Tag alloc] init];
        if (v1Tag == NULL)
        {
            NSLog(@"Failed to create V1.1 tag object");
            return NO;
        }
        if (![v1Tag openPath:path])
        {
            NSLog(@"Failed open file: %s when parsing for V1.1 tag object",[path cString]);
            return NO;
        }
    }
    
    // check that a v1 tag exists and create one if it doesn't
    if (![self v1TagPresent]) [v1Tag newTag];
    
    // copy fields from v2 to v1 tag
    int temp = parse;
    parse = 2;
    if (![self setTitle:[self getTitle]]) result = NO;
    if (![self setArtist:[self getArtist]]) result = NO;
    if (![self setAlbum:[self getAlbum]]) result = NO;
    if (![self setYear:[self getYear]]) result = NO;
    if (![self setTrack:[self getTrack] totalTracks:0]) result = NO;
    if (![self setGenreName:[self getGenreNames]]) result = NO;
    if (![self setComments:[self getComments]]) result = NO;
    parse = temp;
    return result;
}

-(BOOL)copyV1TagToV2Tag
{
    BOOL result = YES;
    
    // check there is a v1 tag to copy information from
    if (!parsedV1) if (![v1Tag openPath:path]) return NO;
    
    
    if (![self v1TagPresent])
    {
        NSLog(@"copyV1TagToV2Tag: No v1 tag present to copy");
        return NO;
    }
    
    // check that v2 tag object exists and create a tag if it doesn't
    if (v2Tag == NULL) 
    {
        v2Tag = [[id3V2Tag alloc] initWithFrameDictionary:[dataDictionary objectForKey:@"frames"]];
        if (v2Tag == NULL)
        {
            NSLog(@"Failed to create V2.3.0 tag object");
            return NO;
        }
        [v2Tag openPath:path];
    }
    
    // check that a v2 tag exists and create one if it doesn't
    if (![self v2TagPresent]) [v2Tag newTag:[[preferences objectForKey:@"Default V2 tag - Major number"] intValue] minor:[[preferences objectForKey:@"Default V2 tag - Minor number"] intValue]];
    
    // copy fields from v1 to v2 tag
    int temp = parse;
    parse = 1;
    if (![self setTitle:[self getTitle]]) result = NO;
    if (![self setArtist:[self getArtist]]) result = NO;
    if (![self setAlbum:[self getAlbum]]) result = NO;
    if (![self setYear:[self getYear]]) result = NO;
    if (![self setTrack:[self getTrack] totalTracks:0]) result = NO;
    if (![self setGenreName:[self getGenreNames]]) result = NO;
    if (![self setComments:[self getComments]]) result = NO;
    temp = parse;
    return result;
}

-(BOOL)newTag:(int)Version
{
    return NO;
}

-(BOOL)dropTag:(BOOL)Version;
{
    return NO;
}

- (void)dealloc
{
    [self releaseAttributes];
    if (externalDictionary != YES) 
        if (dataDictionary != NULL) [dataDictionary release];
    [super dealloc];
}

-(NSMutableArray *)processGenreArray:(NSArray *)Array
{
    // setup a new array to contain the processed variables and allocate an enumerator to step through the array
    NSMutableArray * processedArray = [NSMutableArray arrayWithCapacity:[Array count]];
    NSEnumerator *enumerator = [Array objectEnumerator];
    NSString * anObject;
    NSString * tempString;
    int genreIndex = 0;
    BOOL isNumber = NO;
    
    //The current highest sequence number is stored as in the Dictionary under the key -1.  -1 is not used by the genre system so it should be safe.  
    int sequenceNumber = [[[dataDictionary objectForKey:@"genreIndexes"] objectForKey:@"-1"] intValue];
    
    //Step throught the unprocessed array
    while (anObject = [enumerator nextObject]) 
    {
        //Test the array to determine if it is a string
        //Check the dictionary to see if the genre exits
        
        if ([anObject isEqualToString:@"0"])
        {
            isNumber = YES;
        }
        else 
        {
            genreIndex = [anObject intValue];
            isNumber = YES;
            if (genreIndex == 0) isNumber = NO;
        }
        
        if (isNumber)
        {
            //Converts the number to the equivelent text number. If the number is not found or the number is not in the predefined list then return the UNKNOWN string. 
            tempString = NULL;
            if (genreIndex <= MAX_INDEX_DEFINED_GENRES)
                tempString = [[dataDictionary objectForKey:@"genreIndexes"] objectForKey:anObject];
            if (tempString==NULL)
                [processedArray addObject:@"UNKNOWN"];
            else
                if (![processedArray containsObject:tempString]) [processedArray addObject:tempString];
        }
        else
        {
            tempString = [genreDictionary objectForKey:anObject];
            if ((tempString == NULL)&&(externalDictionary))  
            {//If the genre does not exist in the dictionary and the Dictionary is not the static one provided with the library then add the new genre.
                sequenceNumber++;
                [[dataDictionary objectForKey:@"genreIndexes"] setObject:[NSNumber numberWithInt:sequenceNumber] forKey:@"-1"];
                [genreDictionary setObject:[NSNumber numberWithInt:sequenceNumber] forKey:anObject];
             }
            if (![processedArray containsObject:anObject]) [processedArray addObject:anObject];
        }
    }
    return processedArray;
}

-(void) selectTag:(int)Parse
{
    if (Parse < 0) parse = 0;
    if (Parse > 2) parse = 2;
    else parse = Parse;
}

-(BOOL) tagFound
{
    return ([v1Tag tagPresent]||[v2Tag tagPresent]);
}
@end
