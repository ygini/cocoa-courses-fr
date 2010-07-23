//
//  MagicSlatePhoneAppDelegate.h
//  MagicSlatePhone
//
//  Created by Yoann Gini on 22/04/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MagicSlatePhoneViewController;

@interface MagicSlatePhoneAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MagicSlatePhoneViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MagicSlatePhoneViewController *viewController;

@end

