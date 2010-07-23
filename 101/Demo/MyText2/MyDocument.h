//
//  MyDocument.h
//  MyText
//
//  Created by Yoann GINI on 25/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import <ImagePickerFramework/YGImagePickerController.h>

@interface MyDocument : NSDocument
{
	IBOutlet NSTextView	*textView;
	NSAttributedString	*attributedString;
	YGImagePickerController	*imagePicker;
}

@property (retain) NSAttributedString *attributedString;

-(IBAction)showImagePicker:(id)sender;

@end
