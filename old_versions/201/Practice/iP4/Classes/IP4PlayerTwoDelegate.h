//
//  IP4PlayerTwoDelegate.h
//  iP4
//
//  Created by Yoann Gini on 27/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IP4PlayerTwo;

@protocol IP4PlayerTwoDelegate
@required
-(int)playerTwo:(IP4PlayerTwo*)playerTwo willPlayedColum:(int)column;
-(void)playerTwo:(IP4PlayerTwo*)playerTwo didPlayedColum:(int)column row:(int)row;
-(void)playerTwo:(IP4PlayerTwo*)playerTwo endWithError:(NSString*)error;
-(void)playerTwoStart:(IP4PlayerTwo*)playerTwo;
-(void)playerTwoNotStart:(IP4PlayerTwo*)playerTwo;
@end
