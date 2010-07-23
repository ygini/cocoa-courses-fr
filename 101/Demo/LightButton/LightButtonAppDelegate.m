//
//  LightButtonAppDelegate.m
//  LightButton
//
//  Created by Yoann Gini on 20/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LightButtonAppDelegate.h"

@implementation LightButtonAppDelegate

@synthesize window;

-(IBAction)stateChange:(NSButton*)sender {
	if ([sender state] == NSOnState) [label setStringValue:@"On"];
	else [label setStringValue:@"Off"];
}

@end
