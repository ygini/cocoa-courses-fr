//
//  IPDataProvider.h
//  iPlayer
//
//  Created by Yoann Gini on 31/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "IPMusic.h"


@class NSManagedObjectContext, NSManagedObjectModel, NSPersistentStoreCoordinator;

@interface IPDataProvider : NSObject {
	NSManagedObjectContext		*ipdp_moc;
	NSManagedObjectModel		*ipdp_mom;
	NSPersistentStoreCoordinator	*ipdp_storeCoordinator;
	
	NSString			*ipdb_dataFolder;
}

@property (readonly) NSManagedObjectContext *managedObjectContext;

+(IPDataProvider*)sharedInstance;

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window;
- (IBAction) saveAction:(id)sender;
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender;

- (NSManagedObject*)createIPMusicWithPath:(NSString*)path;

@end
