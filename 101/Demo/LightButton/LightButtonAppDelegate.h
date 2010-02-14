//
//  LightButtonAppDelegate.h
//  LightButton
//
//  Created by Yoann Gini on 20/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LightButtonAppDelegate : NSObject <NSApplicationDelegate> {
	NSWindow *window;
	IBOutlet NSTextField *label;
}

@property (assign) IBOutlet NSWindow *window;

-(IBAction)stateChange:(NSButton*)sender;

@end
