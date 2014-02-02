//
//  IP4GridView.m
//  iP4
//
//  Created by Yoann Gini on 25/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IP4GridView.h"

@implementation IP4GridView

@synthesize gridColor = _gridColor;

@synthesize holdPlayer = _holdPlayer;

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
	    _internalMatrice = [NSMutableDictionary new];
	    self.backgroundColor = [UIColor clearColor];
	    self.autoresizingMask = UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight;
	    _imageSize = 50.0;
	    _buttonLoaded = _holdPlayer = NO;
	    self.gridColor = [UIColor blackColor];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
	if ((self = [super initWithCoder:aDecoder])) {
		_internalMatrice = [NSMutableDictionary new];
		_imageSize = 50.0;
		_buttonLoaded = _holdPlayer = NO;
		self.gridColor = [UIColor blackColor];
	}
	return self;
}

-(void)dropPiece:(UIButton*)button {
	if (_holdPlayer) return;
	int row = [_delegate gridView:self willPlayAtColumn:button.tag-1];
	if (row >= 0) {
		[self reloadViewForColumn:button.tag-1 andRow:row];
		[_delegate gridView:self didPlayAtColumn:button.tag-1 andRow:row];
	}
}

-(void)reloadView {
	for (int i = 0; i < 7; i++) {
		for (int j = 0; j < 6; j++) {
			[self reloadViewForColumn:i andRow:j];
		}
	}
}

-(void)reloadViewForColumn:(int)column andRow:(int)row {
	NSString *key = [NSString stringWithFormat:@"%d-%d", column, row];
	
	UIImageView *imageView = [_internalMatrice valueForKey:key];
	NSString *imageName = [_delegate gridView:self
			       imageNameForColumn:column 
					   andRow:row];
	if (!imageView) {
		if (imageName) {
			imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
			imageView.tag = 10*(column+1)+100*(row+1);
			[_internalMatrice setValue:imageView 
					    forKey:key];
			[self addSubview:imageView];
			[imageView autorelease];
		}
	} else imageView.image = [UIImage imageNamed:imageName];
	imageView.frame = CGRectMake(_offsetX + column * _imageSize, self.frame.size.height - (row+2) * _imageSize, _imageSize, _imageSize);
}

- (void)layoutSubviews {
    NSLog(@"layoutSubviews");
	if (self.frame.size.width <= self.frame.size.height) {
		_imageSize = (int) self.frame.size.width / 8;
	} else {
		_imageSize = (int) self.frame.size.height / 8;
	}

	_offsetX = (self.frame.size.width - _imageSize*8)/2;
	UIButton *button = nil;
	for (int i = 0; i < 7; i++) {
		if (!_buttonLoaded) {
			button = [UIButton buttonWithType:UIButtonTypeCustom];
			[button setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
			button.enabled = NO;
			button.tag = i+1;
			[button addTarget:self action:@selector(dropPiece:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:button];
		} else {
			button = (UIButton*)[self viewWithTag:i+1];
		}
		button.frame = CGRectMake(_offsetX + i * _imageSize, self.frame.size.height - _imageSize, _imageSize, _imageSize);
	}
	_buttonLoaded = YES;
	[self reloadView];
}

- (void)dealloc {
	[_internalMatrice release];
	[_gridColor release], _gridColor = nil;

	[super dealloc];
}

-(void)setHoldPlayer:(BOOL)flag {
	_holdPlayer = flag;
	for (int i = 0; i < 7; i++) {
		((UIButton*)[self viewWithTag:i+1]).enabled = !_holdPlayer;
	}
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetStrokeColorWithColor(context, [_gridColor CGColor]);
	for (int i = 0; i < 8; i++) {
		CGContextAddLines(context, (CGPoint[]){
			CGPointMake(_offsetX + i * _imageSize, 10),
			CGPointMake(_offsetX + i * _imageSize, self.frame.size.height-_imageSize)
		}, 2);
		CGContextStrokePath(context);
	}
}

@end




