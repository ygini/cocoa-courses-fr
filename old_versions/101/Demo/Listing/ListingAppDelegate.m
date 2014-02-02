//
//  ListingAppDelegate.m
//  Listing
//
//  Created by Yoann GINI on 13/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import "ListingAppDelegate.h"

@implementation ListingAppDelegate

@synthesize window, managedObjectContext = lad_managedObjectContext;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}



- (void)dealloc {
	[lad_managedObjectContext release];
	[lad_persistentStoreCoordinator release];
	[lad_managedObjectModel release];
	
	[super dealloc];
}


- (NSString *)applicationSupportDirectory {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
	return [basePath stringByAppendingPathComponent:@"Listing"];
}

- (NSManagedObjectModel *)managedObjectModel {
	
	if (lad_managedObjectModel) return lad_managedObjectModel;
	
	lad_managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
	return lad_managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.  This 
 implementation will create and return a coordinator, having added the 
 store for the application to it.  (The directory for the store is created, 
 if necessary.)
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
	
	if (lad_persistentStoreCoordinator) return lad_persistentStoreCoordinator;
	
	NSManagedObjectModel *mom = [self managedObjectModel];
	if (!mom) {
		NSAssert(NO, @"Managed object model is nil");
		NSLog(@"%@:%s No model to generate a store from", [self class], _cmd);
		return nil;
	}
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *applicationSupportDirectory = [self applicationSupportDirectory];
	NSError *error = nil;
	
	if ( ![fileManager fileExistsAtPath:applicationSupportDirectory isDirectory:NULL] ) {
		if (![fileManager createDirectoryAtPath:applicationSupportDirectory withIntermediateDirectories:NO attributes:nil error:&error]) {
			NSAssert(NO, ([NSString stringWithFormat:@"Failed to create App Support directory %@ : %@", applicationSupportDirectory,error]));
			NSLog(@"Error creating application support directory at %@ : %@",applicationSupportDirectory,error);
			return nil;
		}
	}
	
	NSURL *url = [NSURL fileURLWithPath: [applicationSupportDirectory stringByAppendingPathComponent: @"storedata"]];
	lad_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: mom];
	if (![lad_persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType 
						      configuration:nil 
								URL:url 
							    options:nil 
							      error:&error]){
		[[NSApplication sharedApplication] presentError:error];
		[lad_persistentStoreCoordinator release], lad_persistentStoreCoordinator = nil;
		return nil;
	}    
	
	return lad_persistentStoreCoordinator;
}

/**
 Returns the managed object context for the application (which is already
 bound to the persistent store coordinator for the application.) 
 */

- (NSManagedObjectContext *) managedObjectContext {
	
	if (lad_managedObjectContext) return lad_managedObjectContext;
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (!coordinator) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		[dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
		[dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
		NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
		[[NSApplication sharedApplication] presentError:error];
		return nil;
	}
	lad_managedObjectContext = [[NSManagedObjectContext alloc] init];
	[lad_managedObjectContext setPersistentStoreCoordinator: coordinator];
	
	return lad_managedObjectContext;
}

/**
 Returns the NSUndoManager for the application.  In this case, the manager
 returned is that of the managed object context for the application.
 */

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
	return [[self managedObjectContext] undoManager];
}


/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.  Any encountered errors
 are presented to the user.
 */

- (IBAction) saveAction:(id)sender {
	
	NSError *error = nil;
	
	if (![[self managedObjectContext] commitEditing]) {
		NSLog(@"%@:%s unable to commit editing before saving", [self class], _cmd);
	}
	
	if (![[self managedObjectContext] save:&error]) {
		[[NSApplication sharedApplication] presentError:error];
	}
}


/**
 Implementation of the applicationShouldTerminate: method, used here to
 handle the saving of changes in the application managed object context
 before the application terminates.
 */

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	
	if (!lad_managedObjectContext) return NSTerminateNow;
	
	if (![lad_managedObjectContext commitEditing]) {
		NSLog(@"%@:%s unable to commit editing to terminate", [self class], _cmd);
		return NSTerminateCancel;
	}
	
	if (![lad_managedObjectContext hasChanges]) return NSTerminateNow;
	
	NSError *error = nil;
	if (![lad_managedObjectContext save:&error]) {
		
		// This error handling simply presents error information in a panel with an 
		// "Ok" button, which does not include any attempt at error recovery (meaning, 
		// attempting to fix the error.)  As a result, this implementation will 
		// present the information to the user and then follow up with a panel asking 
		// if the user wishes to "Quit Anyway", without saving the changes.
		
		// Typically, this process should be altered to include application-specific 
		// recovery steps.  
                
		BOOL result = [sender presentError:error];
		if (result) return NSTerminateCancel;
		
		NSString *question = NSLocalizedString(@"Could not save changes while quitting.  Quit anyway?", @"Quit without saves error question message");
		NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
		NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
		NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:question];
		[alert setInformativeText:info];
		[alert addButtonWithTitle:quitButton];
		[alert addButtonWithTitle:cancelButton];
		
		NSInteger answer = [alert runModal];
		[alert release];
		alert = nil;
		
		if (answer == NSAlertAlternateReturn) return NSTerminateCancel;
		
	}
	
	return NSTerminateNow;
}

@end
