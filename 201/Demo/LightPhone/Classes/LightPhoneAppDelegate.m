//
//  LightPhoneAppDelegate.m
//  LightPhone
//
//  Created by Yoann Gini on 22/04/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "LightPhoneAppDelegate.h"
#import "LightPhoneViewController.h"

@implementation LightPhoneAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
