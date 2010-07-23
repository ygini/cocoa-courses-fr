//
//  ListingAppDelegate.h
//  Listing
//
//  Created by Yoann GINI on 13/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ListingAppDelegate : NSObject <NSApplicationDelegate> {
	NSWindow *window;
	NSManagedObjectContext *lad_managedObjectContext;
	NSPersistentStoreCoordinator *lad_persistentStoreCoordinator;
	NSManagedObjectModel *lad_managedObjectModel;
}

@property (assign) IBOutlet NSWindow *window;
@property (readonly) IBOutlet NSManagedObjectContext *managedObjectContext;

@end
