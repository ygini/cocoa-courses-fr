//
//  IP4GridView.h
//  iP4
//
//  Created by Yoann Gini on 25/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IP4GridView : UIView {
	NSMutableDictionary	*_internalMatrice;
	
	id<IP4GridViewDelegate>	_delegate;
	CGFloat		_offsetX;
	CGFloat		_imageSize;
	
	BOOL		_holdPlayer;
	BOOL		_buttonLoaded;
	
	UIColor	*_gridColor;
}

@property (nonatomic, retain) UIColor *gridColor;
@property (nonatomic, assign) BOOL holdPlayer;
@property (nonatomic, assign) IBOutlet id<IP4GridViewDelegate> delegate;

-(void)reloadView;
-(void)reloadViewForColumn:(int)column andRow:(int)row;

@end




