//
//  YGImagePickerController.h
//  ImagePicker
//
//  Created by Yoann GINI on 25/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface YGImagePickerController : NSWindowController <NSTableViewDataSource, NSMetadataQueryDelegate> {
	NSMetadataQuery		*ygip_query;
	NSString		*ygip_path;
	
	IBOutlet NSTableView	*ygip_tableView;
}

@property (copy) NSString *imagePath;
@property (readonly) NSMetadataQuery *query;

+(YGImagePickerController*)imagePickerForPath:(NSString*)path;

@end
