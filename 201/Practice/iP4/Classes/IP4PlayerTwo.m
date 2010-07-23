//
//  IP4PlayerTwo.m
//  iP4
//
//  Created by Yoann Gini on 27/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IP4PlayerTwo.h"

@interface IP4PlayerTwo (Prviate)
- (void) sendDictionary:(NSDictionary *)dict;
@end


@implementation IP4PlayerTwo

@synthesize gameSession = _gameSession;
@synthesize gameMode = _gameMode;
@synthesize delegate = _delegate;

- (id) initWithGameMode:(IP4GameMode)gameMode
{
	self = [super init];
	if (self != nil) {
		_gameMode = gameMode;
		if (_gameMode == IP4GameLink) {
			_peerPicker = [[GKPeerPickerController alloc] init];
			_peerPicker.delegate = self;
		}
	}
	return self;
}

-(void)preparePlayer {
	if (_gameMode == IP4GameLink) [_peerPicker show];
	else {
		[_delegate playerTwoNotStart:self];
	}
}

-(void)stopPlayer {
	[_gameSession disconnectFromAllPeers];
	_gameSession.available = NO;
	[_gameSession setDataReceiveHandler: nil withContext: nil];
	_gameSession.delegate = nil;
	[_gameSession release];
	_gameSession = nil;
}

-(void)secondUserPlay {
	int i = 0, j = 0, flag = 1;
	while (flag) {
		i = arc4random()%7;
		j = [_delegate playerTwo:self willPlayedColum:i];
		if (j >= 0) flag = 0;
	}
	[_delegate playerTwo:self didPlayedColum:i row:j];
}

-(void)localUserHavePlayedColum:(int)column row:(int)row {
	if (_gameMode == IP4GameLink) [self performSelector:@selector(sendDictionary:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:
												   [NSNumber numberWithInt:column], @"column",
												   [NSNumber numberWithInt:row], @"row",
												   nil]
						 afterDelay:0.3];
	else [self performSelector:@selector(secondUserPlay) withObject:nil afterDelay:0.3];
}

-(void)remoteUserHavePlayedColum:(int)column row:(int)row {
	[_delegate playerTwo:self willPlayedColum:column];
	[_delegate playerTwo:self didPlayedColum:column row:row];
}

- (void)dealloc {
	[_peerPicker release];
	[_gameSession release], _gameSession = nil;
	[super dealloc];
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
	GKSession* session = [[GKSession alloc] initWithSessionID:nil displayName:nil sessionMode:GKSessionModePeer];
	[session autorelease];
	return session;
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession: (GKSession *) session {
	self.gameSession = session;
	session.delegate = self;
	[session setDataReceiveHandler: self withContext:nil];
	_peerPicker.delegate = nil;
	[_peerPicker dismiss];
	[_peerPicker autorelease];
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker {
	_peerPicker.delegate = nil;
	[_peerPicker autorelease];
	[_delegate playerTwo:nil endWithError:@"peerPickerControllerDidCancel"];
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
	switch (state)
	{
		case GKPeerStateConnected:
			if ([session.peerID intValue] > [peerID intValue]) {
				[_delegate playerTwoStart:self];
			} else [_delegate playerTwoNotStart:self];
			
			break;
		case GKPeerStateDisconnected:
			[_delegate playerTwo:nil endWithError:@"GKPeerStateDisconnected"];
			break;
	}
}

- (void) sendDictionary:(NSDictionary *)dict {
	[_gameSession sendDataToAllPeers:[NSPropertyListSerialization dataFromPropertyList: dict
										    format: NSPropertyListBinaryFormat_v1_0
									  errorDescription:nil]
			    withDataMode:GKSendDataReliable error:nil];
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
	NSDictionary *dict = [NSPropertyListSerialization propertyListFromData: data
							      mutabilityOption: NSPropertyListImmutable
									format:nil
							      errorDescription:nil];
	[self remoteUserHavePlayedColum:[[dict objectForKey:@"column"] intValue] row:[[dict objectForKey:@"row"] intValue]];
}

@end



