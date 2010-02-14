//
//  YGImagePickerController.h
//  ImagePicker
//
//  Created by Yoann GINI on 25/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface YGImagePickerController : NSWindowController <NSTableViewDataSource> {
	NSMutableArray	*images;
	NSString	*ygip_path;
}

@property (copy) NSString *imagePath;
@property (retain) NSMutableArray *images;

+(YGImagePickerController*)imagePickerForPath:(NSString*)path;

@end
