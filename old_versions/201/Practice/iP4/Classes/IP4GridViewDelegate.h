//
//  IP4GridViewDelegate.h
//  iP4
//
//  Created by Yoann Gini on 27/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IP4GridView;

@protocol IP4GridViewDelegate <NSObject>
@required
-(NSString*)gridView:(IP4GridView*)gridView imageNameForColumn:(int)column andRow:(int)row;
-(int)gridView:(IP4GridView*)gridView willPlayAtColumn:(int)column;
-(void)gridView:(IP4GridView*)gridView didPlayAtColumn:(int)column andRow:(int)row;
@end
