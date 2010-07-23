//
//  YGImagePickerController.m
//  ImagePicker
//
//  Created by Yoann GINI on 25/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import "YGImagePickerController.h"


@implementation YGImagePickerController

@synthesize imagePath = ygip_path, images;

+(YGImagePickerController*)imagePickerForPath:(NSString*)path {
	YGImagePickerController *imagePicker = [[YGImagePickerController alloc] initWithWindowNibName:@"YGImagePicker"];
	imagePicker.imagePath = path;
	return [imagePicker autorelease];
}

- (void) dealloc
{
	[images release];
	[super dealloc];
}


- (void)windowWillLoad {
	images = [[NSMutableArray alloc] init];
	
	NSError	*err = nil;
	NSString *contentFolderPath = [self.imagePath stringByExpandingTildeInPath];
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:contentFolderPath error:&err];
	for (NSString *path in files) {
		NSImage *image = [[NSImage alloc] initWithContentsOfFile:[contentFolderPath stringByAppendingPathComponent:path]];
		if (image) {
			[self.images addObject:image];
			[image release];
		}
	}
}

@end
