//
//  IPController.h
//  iPlayer
//
//  Created by Yoann Gini on 30/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MusicModel;

@interface IPController : NSObject {
	IBOutlet NSTextField	*titleLabel;
	IBOutlet NSTextField	*artistLabel;
	IBOutlet NSTextField	*albumLabel;
	IBOutlet NSImageView	*artworkView;
	
	NSSound			*_soundPlayer;
	BOOL			_isSuspended;
	
	NSMutableArray		*_playList;
	
	MusicModel		*_curentMusic;
	NSInteger		_currentIndex;
	
	MusicModel		*_music; // temp
}

-(IBAction)playPause:(id)sender;
-(IBAction)stop:(id)sender;

-(IBAction)nextTrack:(id)sender;
-(IBAction)previousTrack:(id)sender;

-(IBAction)fastForward:(id)sender;
-(IBAction)rapidReverse:(id)sender;

@end
