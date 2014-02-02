//
//  IPController.m
//  iPlayer
//
//  Created by Yoann Gini on 30/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import "IPController.h"

#import "MusicModel.h"


@interface IPController (Private)
-(void) ipc_updateInfo;
-(void) ipc_setCurrentMusic:(MusicModel*)music;
-(void) ipc_playMusicAtIndex:(NSUInteger)index;
-(void) ipc_playMusic:(MusicModel*)music;
@end


@implementation IPController

// MARK: Action
-(IBAction)playPause:(id)sender {
	if (sender == tableView) [self stop:self];
	
	if (_soundPlayer && !_isSuspended) {
		[_soundPlayer pause];
		_isSuspended = YES;
	} else if (_soundPlayer && _isSuspended) {
		[_soundPlayer resume];
		_isSuspended = NO;
	} else {
		if ([_playList count] == 0) return;
		
		NSUInteger index = [[tableView selectedRowIndexes] firstIndex];
		if (index == NSNotFound) index = 0;
		
		[self ipc_playMusicAtIndex:index];
	}
}

-(IBAction)stop:(id)sender {
	if (!_soundPlayer) return;
	
	[_soundPlayer stop];
	[_soundPlayer release];
	_soundPlayer = nil;
	
	_isSuspended = NO;
	
	[self ipc_setCurrentMusic:nil];
}


-(IBAction)nextTrack:(id)sender {
	if (!_soundPlayer) return;
	
	[self stop:self];
	
	NSInteger index = _currentIndex + 1;
	
	if (index >= [_playList count]) index = 0;
	
	[self ipc_playMusicAtIndex:index];
}

-(IBAction)previousTrack:(id)sender {
	if (!_soundPlayer) return;
	
	[self stop:self];
	
	NSInteger index = _currentIndex - 1;
	
	if (index < 0) index = [_playList count] - 1;
	
	[self ipc_playMusicAtIndex:index];
}


-(IBAction)fastForward:(id)sender {
	NSTimeInterval time = [_soundPlayer currentTime] + 5;
	if (time >= [_soundPlayer duration]) [self stop:self];
	else [_soundPlayer setCurrentTime:time];
}

-(IBAction)rapidReverse:(id)sender {
	NSTimeInterval time = [_soundPlayer currentTime] - 5;
	if (time < 0) time = 0;
	
	[_soundPlayer setCurrentTime:time];
}

-(IBAction)open:(id)sender {
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setAllowsMultipleSelection:YES];
	[openPanel setCanChooseFiles:YES];
	[openPanel setCanChooseDirectories:NO];
	[openPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"mp3",nil]];
	[openPanel setDelegate:self];
	[openPanel setDirectory:[@"~/Music" stringByExpandingTildeInPath]];
	
	if ([openPanel runModal] == NSFileHandlingPanelOKButton) 
		for (NSString *path in [openPanel filenames]) [_playList addObject:[MusicModel musicWithPath:path]];
	if ([panel isVisible]) [tableView reloadData];
}

-(IBAction)togglePlayList:(id)sender {
	[panel setIsVisible:![panel isVisible]];
}

// MARK: Initialize

- (void) awakeFromNib {
	_playList = [[NSMutableArray alloc] init];
	_soundPlayer = nil;
	_curentMusic = nil;
	
	_isSuspended = NO;
	
	[tableView setTarget:self];
	[tableView setDoubleAction:@selector(playPause:)];
}

- (void) dealloc
{
	[_playList release];
	[super dealloc];
}

// MARK: Private

-(void) ipc_updateInfo {
	NSString *title, *artist, *album;
	
	title = _curentMusic.title;
	if (!title) title = @"…";
	artist = _curentMusic.artist;
	if (!artist) artist = @"…";
	album = _curentMusic.album;
	if (!album) album = @"…";
	
	[titleLabel setStringValue:title];
	[artistLabel setStringValue:artist];
	[albumLabel setStringValue:album];
}

-(void) ipc_setCurrentMusic:(MusicModel*)music {
	if (music != _curentMusic) {
		[_curentMusic setIsPlayed:NO];
		id old = _curentMusic;
		_curentMusic = [music retain];
		[old release];
		[_curentMusic setIsPlayed:YES];
		[self ipc_updateInfo];
	}
}

-(void) ipc_playMusicAtIndex:(NSUInteger)index {
	_currentIndex = index;
	[self ipc_playMusic:[_playList objectAtIndex:index]];
}

-(void) ipc_playMusic:(MusicModel*)music {
	[self ipc_setCurrentMusic:music];
	
	_soundPlayer = [[NSSound alloc] initWithContentsOfFile:_curentMusic.path byReference:YES];
	[_soundPlayer play];
	_isSuspended = NO;
	if ([panel isVisible]) [tableView reloadData];
}

// MARK: NSTableView

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
	return [_playList count];
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	return [[_playList objectAtIndex:row] valueForKey:[tableColumn identifier]];
}

- (void) tableView:(NSTableView *)tableView willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	[cell setFont:[[NSFontManager sharedFontManager] convertFont:[cell font] toHaveTrait:
		       [[_playList objectAtIndex:row] isPlayed] ? NSBoldFontMask : NSUnboldFontMask]
	 ];
}

@end
