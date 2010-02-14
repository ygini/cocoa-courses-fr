//
//  iTaxAppDelegate.h
//  iTax
//
//  Created by Yoann GINI on 28/12/09.
//  Copyright 2009 iNig-Services. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface iTaxAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
