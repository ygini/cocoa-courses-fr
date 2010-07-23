//
//  MusicModel.h
//  iPlayer
//
//  Created by Yoann Gini on 30/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MusicModel : NSObject {
	NSString	*_title;
	NSString	*_artist;
	NSString	*_album;
	NSString	*_path;
	NSImage		*_artwork;
	BOOL		_isPlayed;
}

@property (retain) NSString *title;
@property (retain) NSString *artist;
@property (retain) NSString *album;
@property (retain, readonly) NSString *path;
@property (retain, readonly) NSImage *artwork;
@property (assign) BOOL isPlayed;

+(MusicModel*)musicWithPath:(NSString*)path;

@end
