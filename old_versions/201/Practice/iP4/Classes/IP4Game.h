//
//  IP4Game.h
//  iP4
//
//  Created by Yoann Gini on 25/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IP4GridView, IP4PlayerTwo;

@interface IP4Game : UIViewController <IP4GridViewDelegate, IP4PlayerTwoDelegate> {
	IP4GameMode		_gameMode;
	IP4GridView		*_gridView;
	
	IP4PlayerTwo		*_playerTwo;
	
	int			_matrice[7][6];
	int			_currentPlayer;
	int			_totalPiece;
	int			_winner;
	
	id<IP4GameDelegate>	_delegate;
	UIImageView		*_lightStop;
}

@property (nonatomic, retain) IBOutlet UIImageView *lightStop;

@property (nonatomic, assign) id<IP4GameDelegate> delegate;
@property (nonatomic, retain) IBOutlet IP4GridView *gridView;
@property (nonatomic, assign) IP4GameMode gameMode;

@end





