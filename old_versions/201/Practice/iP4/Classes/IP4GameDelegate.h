//
//  IP4GameDelegate.h
//  iP4
//
//  Created by Yoann Gini on 27/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IP4Game;
@protocol IP4GameDelegate
@required
-(void)game:(IP4Game*)game doneWithWinner:(int)winner;
@end
