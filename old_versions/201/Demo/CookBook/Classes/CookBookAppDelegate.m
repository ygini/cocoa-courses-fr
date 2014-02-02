//
//  CookBookAppDelegate.m
//  CookBook
//
//  Created by Yoann GINI on 24/10/08.
//  Copyright iNig-Services 2008. All rights reserved.
//

#import "CookBookAppDelegate.h"

@implementation CookBookAppDelegate

@synthesize window, tabBarController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	[window addSubview:[tabBarController view]];
	[window makeKeyAndVisible];
}


- (void)dealloc {
	[window release];
	[super dealloc];
}


@end
