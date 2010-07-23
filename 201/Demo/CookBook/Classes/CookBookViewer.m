//
//  CookBookViewer.m
//  CookBook
//
//  Created by Yoann GINI on 24/10/08.
//  Copyright 2008 iNig-Services. All rights reserved.
//

#import "CookBookViewer.h"


@implementation CookBookViewer

- (id) init
{
	self = [super init];
	if (self != nil) {
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)updateContentWithTitle:(NSString*)aTitle andContent:(NSString*)aContent {
	self.title = titleLabel.text = aTitle;
	recipeContent.text = aContent;
}

@end
