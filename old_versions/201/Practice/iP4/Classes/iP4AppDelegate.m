//
//  iP4AppDelegate.m
//  iP4
//
//  Created by Yoann Gini on 25/04/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "iP4AppDelegate.h"
#import "IP4GridView.h"
#import "IP4Game.h"

@implementation iP4AppDelegate

@synthesize currentGame = _currentGame;

@synthesize tabBarController = _tabBarController;
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:@"Player", @"playerName",
								 [NSNumber numberWithInt:0], @"totalGames",
								 [NSNumber numberWithInt:0], @"winGames",
								 [NSNumber numberWithInt:0], @"looseGames",
								 [NSNumber numberWithInt:0], @"nullGames",
								 nil]];
	[_window addSubview:_tabBarController.view];
	[_window makeKeyAndVisible];
	return YES;
}

-(void) applicationWillTerminate:(UIApplication *)application {
	[[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)dealloc {
	[_window release], _window = nil;
	[_tabBarController release], _tabBarController = nil;
	[_currentGame release], _currentGame = nil;
	
	[super dealloc];
}

//MARK: -

-(IBAction)startOnePlayerMode {
	self.currentGame = [[[IP4Game alloc] initWithNibName:@"IP4Game" bundle:nil] autorelease];
	self.currentGame.gameMode = IP4GameOnePlayer;
	self.currentGame.delegate = self;
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
	[self.tabBarController presentModalViewController:self.currentGame animated:YES];
}

-(IBAction)startTwoPlayerMode {
	self.currentGame = [[[IP4Game alloc] initWithNibName:@"IP4Game" bundle:nil] autorelease];
	self.currentGame.gameMode = IP4GameTwoPlayer;
	self.currentGame.delegate = self;
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
	[self.tabBarController presentModalViewController:self.currentGame animated:YES];
}

-(IBAction)startLinkMode {
	self.currentGame = [[[IP4Game alloc] initWithNibName:@"IP4Game" bundle:nil] autorelease];
	self.currentGame.gameMode = IP4GameLink;
	self.currentGame.delegate = self;
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
	[self.tabBarController presentModalViewController:self.currentGame animated:YES];
}

//MARK: IP4GameDelegate

-(void) game:(IP4Game *)game doneWithWinner:(int)winner {
	if (winner >= 0)[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] valueForKey:@"totalGames"] intValue]+1]
						 forKey:@"totalGames"];
	if (winner == 0) [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] valueForKey:@"nullGames"] intValue]+1]
						 forKey:@"nullGames"];
	else if (winner == 1) [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] valueForKey:@"winGames"] intValue]+1]
								       forKey:@"winGames"];
	else if (winner == 2) [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] valueForKey:@"looseGames"] intValue]+1]
								       forKey:@"looseGames"];
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	[self.tabBarController dismissModalViewControllerAnimated:YES];
	self.currentGame = nil;
}

@end





