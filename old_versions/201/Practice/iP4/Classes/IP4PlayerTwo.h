//
//  IP4PlayerTwo.h
//  iP4
//
//  Created by Yoann Gini on 27/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface IP4PlayerTwo : NSObject <GKPeerPickerControllerDelegate, GKSessionDelegate> {
	IP4GameMode			_gameMode;
	GKPeerPickerController	*_peerPicker;
	GKSession			*_gameSession;
	
	id<IP4PlayerTwoDelegate, IP4GridViewDelegate>	_delegate;
}

@property (nonatomic, retain) GKSession *gameSession;

@property (nonatomic, assign) id<IP4PlayerTwoDelegate, IP4GridViewDelegate> delegate;
@property (nonatomic, assign) IP4GameMode gameMode;

-(void)preparePlayer;
-(void)stopPlayer;

-(IP4PlayerTwo*)initWithGameMode:(IP4GameMode)gameMode;
-(void)localUserHavePlayedColum:(int)column row:(int)row;

@end



