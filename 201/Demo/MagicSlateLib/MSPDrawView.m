//
//  MSPDrawView.m
//  MagicSlatePhone
//
//  Created by Yoann Gini on 22/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSPDrawView.h"


@implementation MSPDrawView

@synthesize imageName = _imageName;

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint targetPoint = [[touches anyObject] locationInView:self];
	_lastImage = [[UIImageView alloc] initWithFrame:CGRectMake(targetPoint.x,
										targetPoint.y,
									       50, 50)];
	_lastImage.image = [UIImage imageNamed:self.imageName];
	[self addSubview:_lastImage];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint targetPoint = [[touches anyObject] locationInView:self];
	_lastImage.frame = CGRectMake(targetPoint.x,
				      targetPoint.y,
				      50, 50);
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[_lastImage removeFromSuperview];
	[_lastImage release];
	_lastImage = nil;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[_lastImage release];
	_lastImage = nil;
}

- (void)dealloc
{
	[_imageName release], _imageName = nil;
	
	[super dealloc];
}

@end

