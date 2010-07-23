//
//  MusicModel.m
//  iPlayer
//
//  Created by Yoann Gini on 30/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import "MusicModel.h"


@interface MusicModel (Private)
-(void)mm_setPath:(NSString*)path;
-(void)mm_setImage:(NSImage*)image;
@end

@implementation MusicModel


@synthesize title = _title;
@synthesize artist = _artist;
@synthesize album = _album;
@synthesize path = _path;
@synthesize artwork = _artwork;
@synthesize isPlayed = _isPlayed;

// MARK: Creation

+(MusicModel*)musicWithPath:(NSString*)path {
	MusicModel* music = [[MusicModel alloc] init];
	[music mm_setPath:path];
	
	return [music autorelease];
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		_title = @"Il reste à lire les ID3 Tag";
		_artist = nil;
		_album = nil;
		_path = nil;
		_artwork = nil;
	}
	return self;
}


// MARK: Private

-(void)mm_setPath:(NSString*)path {
	if (path != _path) {
		id old = _path;
		_path = [path copy];
		[old release];
	}
}

-(void)mm_setImage:(NSImage*)image {
	if (image != _artwork) {
		id old = _artwork;
		_artwork = [image copy];
		[old release];
	}
}

@end
