//
//  iP4AppDelegate.h
//  iP4
//
//  Created by Yoann Gini on 25/04/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IP4Game.h";

@interface iP4AppDelegate : NSObject <UIApplicationDelegate, IP4GameDelegate> {
	UIWindow *_window;
	UITabBarController	*_tabBarController;
	
	IP4Game *_currentGame;
}

@property (nonatomic, retain) IP4Game *currentGame;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UIWindow *window;

-(IBAction)startOnePlayerMode;
-(IBAction)startTwoPlayerMode;
-(IBAction)startLinkMode;

@end






