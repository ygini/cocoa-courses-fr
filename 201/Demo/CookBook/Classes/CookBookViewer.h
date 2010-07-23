//
//  CookBookViewer.h
//  CookBook
//
//  Created by Yoann GINI on 24/10/08.
//  Copyright 2008 iNig-Services. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CookBookViewer : UIViewController {
	IBOutlet UILabel*	titleLabel;
	IBOutlet UITextView*	recipeContent;
}

-(void)updateContentWithTitle:(NSString*)aTitle andContent:(NSString*)aContent;

@end
