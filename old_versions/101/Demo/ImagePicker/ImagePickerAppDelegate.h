//
//  ImagePickerAppDelegate.h
//  ImagePicker
//
//  Created by Yoann GINI on 25/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class YGImagePickerController;

@interface ImagePickerAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	YGImagePickerController *imagePicker;
}

@property (assign) IBOutlet NSWindow *window;

-(IBAction)showImagePicker:(id)sender;

@end
