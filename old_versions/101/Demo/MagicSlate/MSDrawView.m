//
//  MSDrawView.m
//  MagicSlate
//
//  Created by Yoann GINI on 22/01/10.
//  Copyright 2010 iNig-Services. All rights reserved.
//

#import "MSDrawView.h"


@implementation MSDrawView


- (void)mouseUp:(NSEvent *)theEvent {
	if ([self mouse:[self convertPoint:[theEvent locationInWindow]fromView:nil]
		 inRect:[self frame]]) {
		NSPoint targetPoint = [self convertPoint:[theEvent locationInWindow]
						fromView:nil];
		
		NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(targetPoint.x,
													targetPoint.y,
													50, 50))];
		[imageView setImage:[NSImage imageNamed:@"light.png"]];
		[self addSubview:imageView];
		[imageView release];
	}
}

@end
