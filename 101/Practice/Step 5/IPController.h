//
//  IPController.h
//  iPlayer
//
//  Created by Yoann Gini on 30/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IPMusic, IPDataProvider;

@interface IPController : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate, NSDrawerDelegate, NSOpenSavePanelDelegate> {
	IBOutlet NSTableView	*tableView;
	
	IBOutlet NSPanel	*panel;
	
	IBOutlet NSArrayController	*playList;
	
	NSSound			*_soundPlayer;
	BOOL			_isSuspended;
	
	IPMusic			*_curentMusic;
	NSInteger		_currentIndex;
}

@property (readonly) IPMusic *curentMusic;
@property (readonly) IPDataProvider *dataProvider;

-(IBAction)playPause:(id)sender;
-(IBAction)stop:(id)sender;

-(IBAction)nextTrack:(id)sender;
-(IBAction)previousTrack:(id)sender;

-(IBAction)fastForward:(id)sender;
-(IBAction)rapidReverse:(id)sender;

-(IBAction)open:(id)sender;
-(IBAction)togglePlayList:(id)sender;

@end
