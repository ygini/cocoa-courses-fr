//
//  LightPhoneAppDelegate.h
//  LightPhone
//
//  Created by Yoann Gini on 22/04/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LightPhoneViewController;

@interface LightPhoneAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    LightPhoneViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LightPhoneViewController *viewController;

@end

