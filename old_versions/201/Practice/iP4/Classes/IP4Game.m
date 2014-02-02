//
//  IP4Game.m
//  iP4
//
//  Created by Yoann Gini on 25/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IP4Game.h"

#import "IP4GridView.h"
#import "IP4PlayerTwo.h"

@implementation IP4Game

@synthesize lightStop = _lightStop;

@synthesize gridView = _gridView;
@synthesize gameMode = _gameMode;
@synthesize delegate = _delegate;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self != nil) {
		self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	}
	return self;
}

-(void)holdLocalPlayer:(BOOL)flag {
	_lightStop.image = [UIImage imageNamed:flag ? @"light-on.png" : @"light-off.png"];
	_gridView.holdPlayer = flag;
}

- (void)loadView {
	[super loadView];
	_playerTwo = [[IP4PlayerTwo alloc] initWithGameMode:_gameMode];
	_playerTwo.delegate = self;
	_gridView.delegate = self;
	_gridView.gridColor = [UIColor whiteColor];
	
	bzero(_matrice, sizeof(_matrice));
	_winner = _totalPiece = 0;
	_currentPlayer = -1;
}

-(void) viewDidAppear:(BOOL)animated {
	[self holdLocalPlayer:YES];
	[_playerTwo preparePlayer];
}

-(NSString *) gridView:(IP4GridView *)gridView imageNameForColumn:(int)column andRow:(int)row {
	switch (_matrice[column][row]) {
		case 1:
			return @"Blue.png";
		case 2:
			return @"Gray.png";
		default:
			return nil;
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[_playerTwo stopPlayer];
	[_delegate game:self doneWithWinner:_winner];
}

-(void)gameIsDone {
	_winner = _currentPlayer + 1;
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game is done!" message:[NSString stringWithFormat:@"Player %d win!", _currentPlayer+1] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

-(void)gameIsOver {
	_winner = 0;
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game is over!" message:[NSString stringWithFormat:@"No winner…", _currentPlayer+1] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

-(int) gridView:(IP4GridView *)gridView willPlayAtColumn:(int)column {
	for (int i = 0; i < 6; i++) {
		if (_matrice[column][i] == 0) {
			_matrice[column][i] = _currentPlayer+1;
			return i;
		}
	}
	return -1;
}

-(int)playerTwo:(IP4PlayerTwo*)playerTwo willPlayedColum:(int)column {
	return [self gridView:nil willPlayAtColumn:column];
}

-(void)gridView:(IP4GridView*)gridView didPlayAtColumn:(int)column andRow:(int)row {
	_totalPiece++;
	
	int count = 0;
	int i, j;
	
	i = row - 3;
	if (i < 0) i = 0;
	for (; i <= row + 3 && i < 6 && count < 4; i++) {
		if (_matrice[column][i] == _currentPlayer +1) count++;
		else count = 0;
	}
	if (count == 4) {
		[self gameIsDone];
		return;
	}
	
	i = column - 3;
	count = 0;
	if (i < 0) i = 0;
	for (; i <= column + 3 && i < 7 && count < 4; i++) {
		if (_matrice[i][row] == _currentPlayer +1) count++;
		else count = 0;
	}
	if (count == 4) {
		[self gameIsDone];
		return;
	}
	
	count = 0;
	i = column - 3;
	j = row - 3;
	for (; (i <= column + 3 && i < 7) && (j <= row + 3 && j < 6) && count < 4; i++, j++) {
		if ((i >= 0 && j >= 0) && (i < 7 && j < 7)) {
			if (_matrice[i][j] == _currentPlayer +1) count++;
			else count = 0;
		}
	}
	if (count == 4) {
		[self gameIsDone];
		return;
	}
	
	count = 0;
	i = column + 3;
	j = row - 3;
	for (; (i >= column - 3 && i >= 0) && (j <= row + 3 && j < 6) && count < 4; i--, j++) {
		if ((i >= 0 && j >= 0) && (i < 7 && j < 7)) {
			if (_matrice[i][j] == _currentPlayer +1) count++;
			else count = 0;
		}
	}
	if (count == 4) {
		[self gameIsDone];
		return;
	}
	
	if (_totalPiece == 42) {
		[self gameIsOver];
		return;
	}
	_currentPlayer = (_currentPlayer+1)%2;
	if (_currentPlayer != 0 && _gameMode != IP4GameTwoPlayer) {
		[self holdLocalPlayer:YES];
		[_playerTwo localUserHavePlayedColum:column row:row];
	} else [self holdLocalPlayer:NO];
}


-(void)playerTwo:(IP4PlayerTwo*)playerTwo didPlayedColum:(int)column row:(int)row {
	[self gridView:nil didPlayAtColumn:column andRow:row];
	[_gridView reloadViewForColumn:column andRow:row];
}

-(void)playerTwo:(IP4PlayerTwo*)playerTwo endWithError:(NSString*)error {
	[_delegate game:self doneWithWinner:-1];
}

-(void)playerTwoStart:(IP4PlayerTwo*)playerTwo {
	_currentPlayer = 1;
	[self holdLocalPlayer:YES];
}

-(void)playerTwoNotStart:(IP4PlayerTwo*)playerTwo {
	_currentPlayer = 0;
	[self holdLocalPlayer:NO];
}

- (void)dealloc {
	[_gridView release], _gridView = nil;
	[_lightStop release], _lightStop = nil;

	[super dealloc];
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

@end





