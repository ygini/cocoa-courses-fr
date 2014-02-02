//
//  IPDataProvider.m
//  iPlayer
//
//  Created by Yoann Gini on 31/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import "IPDataProvider.h"

#import <CoreData/CoreData.h>
#import <ID3/TagAPI.h>


@implementation IPDataProvider

@synthesize managedObjectContext = ipdp_moc;

+(IPDataProvider*)sharedInstance {
	static IPDataProvider *sharedInstanceIPDataProvider = nil;
	if (!sharedInstanceIPDataProvider) sharedInstanceIPDataProvider =[[IPDataProvider alloc] init];
	return sharedInstanceIPDataProvider;
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		ipdb_dataFolder = [[NSString alloc] initWithString:[@"~/Music/iPlayer" stringByExpandingTildeInPath]];
		
		ipdp_mom = nil;  
		ipdp_moc = nil;
		ipdp_storeCoordinator = nil;
	}
	return self;
}

- (NSManagedObject*)createIPMusicWithPath:(NSString*)path {
	NSManagedObject *music = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"IPMusic" inManagedObjectContext:ipdp_moc]
					  insertIntoManagedObjectContext:ipdp_moc];
	
	TagAPI *tag = [[TagAPI alloc] initWithPath:path genreDictionary:nil];
	[music setValue:path forKey:@"path"];
	
	if ([tag tagFound]) {
		[music setValue:[tag getArtist] forKey:@"artist"];
		[music setValue:[tag getAlbum] forKey:@"album"];
		[music setValue:[tag getTitle] forKey:@"title"];
	}
	
	return [music autorelease];
}


// MARK: Generated Methods

- (NSManagedObjectModel *)managedObjectModel {
	if (!ipdp_mom) ipdp_mom = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
	return ipdp_mom;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
	
	if (ipdp_storeCoordinator) return ipdp_storeCoordinator;
	
	NSManagedObjectModel *mom = [self managedObjectModel];
	if (!mom) {
		NSAssert(NO, @"Managed object model is nil");
		NSLog(@"%@:%s No model to generate a store from", [self class], _cmd);
		return nil;
	}
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error = nil;
	
	if ( ![fileManager fileExistsAtPath:ipdb_dataFolder isDirectory:NULL] ) {
		if (![fileManager createDirectoryAtPath:ipdb_dataFolder withIntermediateDirectories:NO attributes:nil error:&error]) {
			NSAssert(NO, ([NSString stringWithFormat:@"Failed to create App Support directory %@ : %@", ipdb_dataFolder,error]));
			NSLog(@"Error creating application support directory at %@ : %@",ipdb_dataFolder,error);
			return nil;
		}
	}
	
	NSURL *url = [NSURL fileURLWithPath: [ipdb_dataFolder stringByAppendingPathComponent: @"library"]];
	ipdp_storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: mom];
	if (![ipdp_storeCoordinator addPersistentStoreWithType:NSXMLStoreType 
							  configuration:nil 
								    URL:url 
								options:nil 
								  error:&error]){
		[[NSApplication sharedApplication] presentError:error];
		[ipdp_storeCoordinator release], ipdp_storeCoordinator = nil;
		return nil;
	}    
	
	return ipdp_storeCoordinator;
}

- (NSManagedObjectContext *) managedObjectContext {
	
	if (ipdp_moc) return ipdp_moc;
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (!coordinator) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		[dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
		[dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
		NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
		[[NSApplication sharedApplication] presentError:error];
		return nil;
	}
	ipdp_moc = [[NSManagedObjectContext alloc] init];
	[ipdp_moc setPersistentStoreCoordinator: coordinator];
	
	return ipdp_moc;
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
	return [[self managedObjectContext] undoManager];
}

- (IBAction) saveAction:(id)sender {
	
	NSError *error = nil;
	
	if (![[self managedObjectContext] commitEditing]) {
		NSLog(@"%@:%s unable to commit editing before saving", [self class], _cmd);
	}
	
	if (![[self managedObjectContext] save:&error]) {
		[[NSApplication sharedApplication] presentError:error];
	}
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	
	if (!ipdp_moc) return NSTerminateNow;
	
	if (![ipdp_moc commitEditing]) {
		NSLog(@"%@:%s unable to commit editing to terminate", [self class], _cmd);
		return NSTerminateCancel;
	}
	
	if (![ipdp_moc hasChanges]) return NSTerminateNow;
	
	NSError *error = nil;
	if (![ipdp_moc save:&error]) {
                
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
