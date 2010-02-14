//
//  IPController.h
//  iPlayer
//
//  Created by Yoann Gini on 30/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MusicModel;

@interface IPController : NSObject <NSTableViewDataSource, NSTableViewDelegate, NSDrawerDelegate, NSOpenSavePanelDelegate> {
	IBOutlet NSWindow	*mainWindow;
	IBOutlet NSTextField	*titleLabel;
	IBOutlet NSTextField	*artistLabel;
	IBOutlet NSTextField	*albumLabel;
	IBOutlet NSImageView	*artworkView;
	
	IBOutlet NSTableView	*tableView;
	
	IBOutlet NSPanel	*panel;
	
	NSSound			*_soundPlayer;
	BOOL			_isSuspended;
	
	NSMutableArray		*_playList;
	
	MusicModel		*_curentMusic;
	NSInteger		_currentIndex;
}

-(IBAction)playPause:(id)sender;
-(IBAction)stop:(id)sender;

-(IBAction)nextTrack:(id)sender;
-(IBAction)previousTrack:(id)sender;

-(IBAction)fastForward:(id)sender;
-(IBAction)rapidReverse:(id)sender;

-(IBAction)open:(id)sender;
-(IBAction)togglePlayList:(id)sender;

@end
