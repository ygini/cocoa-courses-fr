//
//  YGImagePickerController.h
//  ImagePicker
//
//  Created by Yoann GINI on 25/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface YGImagePickerController : NSWindowController <NSTableViewDataSource> {
	NSMutableArray	*ygip_images;
	NSString	*ygip_path;
	
	IBOutlet NSTableView	*ygip_tableView;
}

@property (copy) NSString *imagePath;

+(YGImagePickerController*)imagePickerForPath:(NSString*)path;

@end
