//
//  iTaxAppDelegate.h
//  iTax
//
//  Created by Yoann GINI on 28/12/09.
//  Copyright 2009 iNig-Services. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface iTaxAppDelegate : NSObject <NSApplicationDelegate> {
	NSWindow	*window;
	NSTextField	*i_incTaxField;
	NSTextField	*i_excTaxField;
	NSTextField	*i_taxAmmountField;
	NSTableView	*i_historyView;
	
	NSMutableArray	*i_history;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *incTaxField;
@property (assign) IBOutlet NSTextField *excTaxField;
@property (assign) IBOutlet NSTextField *taxAmmountField;
@property (assign) IBOutlet NSTableView *historyView;

-(IBAction)memorizeIt:(id)sender;

@end
