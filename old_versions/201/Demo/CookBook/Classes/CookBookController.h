//
//  CookBookController.h
//  CookBook
//
//  Created by Yoann GINI on 24/10/08.
//  Copyright 2008 iNig-Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CookBookViewer;

@interface CookBookController : NSObject {
	IBOutlet UITableView*		drinkTableView;
	IBOutlet UITableView*		starterTableView;
	IBOutlet UITableView*		mealTableView;
	IBOutlet UITableView*		dessertTableView;
	
	IBOutlet UINavigationController*	drinkNavViewController;
	IBOutlet UINavigationController*	starterNavViewController;
	IBOutlet UINavigationController*	mealNavViewController;
	IBOutlet UINavigationController*	dessertNavViewController;
	
	IBOutlet UITabBarController*	tabBarC;
	
	IBOutlet CookBookViewer*	recipeViewer;
	
	NSDictionary*			recipeDictionnary;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

-(NSString*)nameOfTableView:(UITableView*)aTableView;
-(UINavigationController*)viewControllerOfTableView:(UITableView*)aTableView;

@end
