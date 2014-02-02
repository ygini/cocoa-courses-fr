//
//  CookBookAppDelegate.h
//  CookBook
//
//  Created by Yoann GINI on 24/10/08.
//  Copyright iNig-Services 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CookBookAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow*		window;
	UITabBarController*	tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end

