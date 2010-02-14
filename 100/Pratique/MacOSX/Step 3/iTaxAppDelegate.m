//
//  iTaxAppDelegate.m
//  iTax
//
//  Created by Yoann GINI on 28/12/09.
//  Copyright 2009 iNig-Services. All rights reserved.
//

#import "iTaxAppDelegate.h"

@implementation iTaxAppDelegate

@synthesize window;
@synthesize incTaxField = i_incTaxField, excTaxField = i_excTaxField, taxAmmountField = i_taxAmmountField, historyView = i_historyView;

- (id) init
{
	self = [super init];
	if (self != nil) {
		i_history = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

-(IBAction)memorizeIt:(id)sender {
	float excVal = [i_excTaxField floatValue];
	float taxVal = [i_taxAmmountField floatValue];
	float incVal = [i_incTaxField floatValue];
		
	if (excVal != 0) incVal = excVal * (1+taxVal/100);
	else if (incVal != 0) excVal = incVal / (1+taxVal/100);
	
	[i_history addObject:[NSDictionary dictionaryWithObjectsAndKeys:
			     [NSNumber numberWithFloat:excVal], @"excVal", 
			     [NSNumber numberWithFloat:taxVal], @"taxVal", 
			     [NSNumber numberWithFloat:incVal], @"incVal",
			     nil]];
	
	[i_historyView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [i_history count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	return [[i_history objectAtIndex:rowIndex] valueForKey:[aTableColumn identifier]];
}

@end
