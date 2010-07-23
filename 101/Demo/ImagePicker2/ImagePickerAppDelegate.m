//
//  ImagePickerAppDelegate.m
//  ImagePicker
//
//  Created by Yoann GINI on 25/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import "ImagePickerAppDelegate.h"
#import "YGImagePickerController.h"

@implementation ImagePickerAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	imagePicker = [[YGImagePickerController imagePickerForPath:@"~/Desktop/Demo"] retain];
}

- (void) dealloc
{
	[imagePicker release];
	[super dealloc];
}


-(IBAction)showImagePicker:(id)sender {
	[imagePicker showWindow:self];
}

@end
