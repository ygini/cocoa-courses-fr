//
//  CookBookController.m
//  CookBook
//
//  Created by Yoann GINI on 24/10/08.
//  Copyright 2008 iNig-Services. All rights reserved.
//

#import "CookBookController.h"
#import "CookBookViewer.h"

@implementation CookBookController

- (id) init
{
	self = [super init];
	if (self != nil) {
		recipeDictionnary	= [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recipe" ofType:@"plist"]];
	}
	return self;
}

- (void) dealloc
{
	[recipeDictionnary release];
	[super dealloc];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [(NSDictionary*)[recipeDictionnary objectForKey:[self nameOfTableView:tableView]] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[(NSDictionary*)[recipeDictionnary objectForKey:[self nameOfTableView:tableView]] objectForKey:
		 [[(NSDictionary*)[recipeDictionnary objectForKey:[self nameOfTableView:tableView]] allKeys] objectAtIndex:section]
		 ]
		count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[(NSDictionary*)[recipeDictionnary objectForKey:[self nameOfTableView:tableView]] allKeys] objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString*	cellIdentifierBaseCell		= @"cellIdentifierBaseCell";
	UITableViewCell*	cell				= nil;
	
	cell			= [tableView dequeueReusableCellWithIdentifier:cellIdentifierBaseCell];
	
	if (!cell) cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifierBaseCell] autorelease];
	
	cell.textLabel.text = [[[(NSDictionary*)[recipeDictionnary objectForKey:[self nameOfTableView:tableView]] objectForKey:
						      [[(NSDictionary*)[recipeDictionnary objectForKey:[self nameOfTableView:tableView]] allKeys] objectAtIndex:indexPath.section]]
		      allKeys] objectAtIndex:indexPath.row];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString*	tableName	= [self nameOfTableView:tableView];
	
	[recipeViewer updateContentWithTitle:[tableView cellForRowAtIndexPath:indexPath].textLabel.text
				  andContent:[(NSDictionary*)[(NSDictionary*)[recipeDictionnary objectForKey:tableName] 
							      objectForKey:[[(NSDictionary*)[recipeDictionnary objectForKey:tableName] allKeys] objectAtIndex:indexPath.section]] 
					      objectForKey:[tableView cellForRowAtIndexPath:indexPath].textLabel.text]];
	
	[[self viewControllerOfTableView:tableView] pushViewController:recipeViewer animated:YES];
}

-(NSString*)nameOfTableView:(UITableView*)aTableView {
	if (aTableView == drinkTableView) return @"drink";
	else if (aTableView == starterTableView) return @"starter";
	else if (aTableView == mealTableView) return @"meal";
	else if (aTableView == dessertTableView) return @"dessert";
	else return @"ERROR";
}

-(UINavigationController*)viewControllerOfTableView:(UITableView*)aTableView {
	if (aTableView == drinkTableView) return drinkNavViewController;
	else if (aTableView == starterTableView) return starterNavViewController;
	else if (aTableView == mealTableView) return mealNavViewController;
	else if (aTableView == dessertTableView) return dessertNavViewController;
	else return nil;
}

@end
