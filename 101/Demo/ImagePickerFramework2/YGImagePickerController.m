//
//  YGImagePickerController.m
//  ImagePicker
//
//  Created by Yoann GINI on 25/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import "YGImagePickerController.h"


@implementation YGImagePickerController

@synthesize imagePath = ygip_path, query = ygip_query;

+(YGImagePickerController*)imagePickerForPath:(NSString*)path {
	YGImagePickerController *imagePicker = [[YGImagePickerController alloc] initWithWindowNibName:@"YGImagePicker"];
	imagePicker.imagePath = path;
	return [imagePicker autorelease];
}

- (id) initWithWindowNibName:(NSString *)windowNibName {
	self = [super initWithWindowNibName:windowNibName];
	if (self) {
		ygip_path = @"~/Images";
		ygip_query = [[NSMetadataQuery alloc] init];
		[ygip_query setPredicate:[NSPredicate predicateWithFormat:@"(%K == %@)", kMDItemContentTypeTree, kUTTypeImage]];
		[ygip_query setSearchScopes:[NSArray arrayWithObject:[self.imagePath stringByExpandingTildeInPath]]];
		[ygip_query setDelegate:self];
	}
	return self;
}

- (void) dealloc
{
	[ygip_query release];
	[super dealloc];
}

-(id) metadataQuery:(NSMetadataQuery *)query replacementObjectForResultObject:(NSMetadataItem *)result {
	return [[[NSImage alloc] initWithContentsOfFile:[result valueForAttribute:(id)kMDItemPath]] autorelease];
}

- (void)windowWillLoad {
	[ygip_query startQuery];
}

- (void) setImagePath:(NSString *)aPath {
	if (aPath != ygip_path) {
		[ygip_query stopQuery];
		id old = ygip_path;
		ygip_path = [aPath copy];
		[old release];
		[ygip_query setSearchScopes:[NSArray arrayWithObject:[ygip_path stringByExpandingTildeInPath]]];
		[ygip_query startQuery];
	}
}

- (BOOL) tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
	[pboard clearContents];
	return [pboard writeObjects:[NSArray arrayWithObject:[[ygip_query results] objectAtIndex:[rowIndexes firstIndex]]]];
}

@end
