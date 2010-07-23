//
//  YGImagePickerController.m
//  ImagePicker
//
//  Created by Yoann GINI on 25/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import "YGImagePickerController.h"


@implementation YGImagePickerController

@synthesize imagePath = ygip_path;

+(YGImagePickerController*)imagePickerForPath:(NSString*)path {
	YGImagePickerController *imagePicker = [[YGImagePickerController alloc] initWithWindowNibName:@"YGImagePicker"];
	imagePicker.imagePath = path;
	return [imagePicker autorelease];
}

- (id) initWithWindowNibName:(NSString *)windowNibName {
	self = [super initWithWindowNibName:windowNibName];
	
	if (self) {
		ygip_path = nil;
		ygip_images = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) dealloc
{
	[ygip_images release];
	[super dealloc];
}


- (void)windowWillLoad {	
	NSError	*err = nil;
	NSString *contentFolderPath = [self.imagePath stringByExpandingTildeInPath];
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:contentFolderPath error:&err];
	for (NSString *path in files) {
		NSImage *image = [[NSImage alloc] initWithContentsOfFile:[contentFolderPath stringByAppendingPathComponent:path]];
		if (image) {
			[ygip_images addObject:image];
			[image release];
		}
	}
	[ygip_tableView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView*)aTableView {
	return [ygip_images count];
}

- (id)tableView:(NSTableView*)aTableView objectValueForTableColumn:(NSTableColumn*)aTableColumn row:(NSInteger)row {
	return [ygip_images objectAtIndex:row];
}

@end
