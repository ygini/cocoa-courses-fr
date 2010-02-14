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
	if (_soundPlayer && !_isSuspended) {
		[_soundPlayer pause];
		_isSuspended = YES;
	} else if (_soundPlayer && _isSuspended) {
		[_soundPlayer resume];
		_isSuspended = NO;
	} else {
		//if ([_playList count] == 0) return;
		
		NSUInteger index = 0; // temp
		
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
	
}

-(IBAction)previousTrack:(id)sender {
	
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

// MARK: Initialize

- (void) awakeFromNib {
	_playList = [[NSMutableArray alloc] init];
	_soundPlayer = nil;
	_curentMusic = nil;
	
	_isSuspended = NO;
	
	// temp
	_music = [[MusicModel musicWithPath:
		   [[NSBundle mainBundle] pathForResource:@"ModelViewController" ofType:@"mp3"]] 
		  retain];
}

- (void) dealloc
{
	if (_soundPlayer) [self stop:self];
	[_playList release];
	
	[_music release]; // temp
	
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
		id old = _curentMusic;
		_curentMusic = [music retain];
		[old release];
		[self ipc_updateInfo];
	}
}

-(void) ipc_playMusicAtIndex:(NSUInteger)index {
	_currentIndex = index;
	//[self ipc_playMusic:[_playList objectAtIndex:index]];
	[self ipc_playMusic:_music]; // temp
}

-(void) ipc_playMusic:(MusicModel*)music {
	[self ipc_setCurrentMusic:music];
	
	_soundPlayer = [[NSSound alloc] initWithContentsOfFile:_curentMusic.path byReference:YES];
	[_soundPlayer play];
	_isSuspended = NO;
}

@end
