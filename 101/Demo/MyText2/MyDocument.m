//
//  MyDocument.m
//  MyText
//
//  Created by Yoann GINI on 25/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import "MyDocument.h"

@implementation MyDocument

@synthesize attributedString;

- (id)init
{
	self = [super init];
	if (self) {
		
	}
	return self;
}

- (void) dealloc
{
	[imagePicker release];
	[attributedString release];
	[super dealloc];
}

-(IBAction)showImagePicker:(id)sender {
	[imagePicker showWindow:self];
}

- (NSString *)windowNibName
{
	return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
	[super windowControllerDidLoadNib:aController];
	if (self.attributedString) [[textView textStorage] setAttributedString:self.attributedString];
	imagePicker = [[YGImagePickerController imagePickerForPath:@"~/Desktop/Demo"] retain];
}

-(BOOL) writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError {
	NSTextStorage	*text = [textView textStorage];
	NSDictionary	*attributes = [NSDictionary dictionaryWithObject:NSRTFDTextDocumentType forKey:NSDocumentTypeDocumentAttribute];
	NSFileWrapper	*fileWrapper = [text fileWrapperFromRange:NSMakeRange(0, [text length]) documentAttributes:attributes error:outError];
	return [fileWrapper writeToURL:absoluteURL options:NSFileWrapperWritingAtomic originalContentsURL:nil error:outError];
}

-(BOOL) readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError {
	NSDictionary	*options = [NSDictionary dictionaryWithObject:NSRTFDTextDocumentType forKey:NSDocumentTypeDocumentAttribute];
	self.attributedString = [[[NSAttributedString alloc] initWithURL:absoluteURL options:options documentAttributes:nil error:outError] autorelease];
	return self.attributedString != nil;
}

@end
