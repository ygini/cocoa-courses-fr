//
//  IP4Settings.m
//  iP4
//
//  Created by Yoann Gini on 25/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IP4Settings.h"


@implementation IP4Settings

@synthesize tableView = _tableView;


- (void)dealloc
{
	[_tableView release], _tableView = nil;

	[super dealloc];
}

-(void) viewDidLoad {
	_tableView.backgroundColor = [UIColor clearColor];
}

-(void) viewWillAppear:(BOOL)animated {
	[_tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	if (section == 0) return 4;
	else return 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellID = @"cellID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	
	if (!cell) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID] autorelease];
	
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = NSLocalizedString(@"totalGames", @"totalGames");
					cell.detailTextLabel.text = [[[NSUserDefaults standardUserDefaults] valueForKey:@"totalGames"] stringValue];
					break;
				case 1:
					cell.textLabel.text = NSLocalizedString(@"winGames", @"totalGames");
					cell.detailTextLabel.text = [[[NSUserDefaults standardUserDefaults] valueForKey:@"winGames"] stringValue];
					break;
				case 2:
					cell.textLabel.text = NSLocalizedString(@"looseGames", @"totalGames");
					cell.detailTextLabel.text = [[[NSUserDefaults standardUserDefaults] valueForKey:@"looseGames"] stringValue];
					break;
				case 3:
					cell.textLabel.text = NSLocalizedString(@"nullGames", @"totalGames");
					cell.detailTextLabel.text = [[[NSUserDefaults standardUserDefaults] valueForKey:@"nullGames"] stringValue];
					break;
			}
			break;
		default:
			cell.textLabel.text = nil;
			cell.detailTextLabel.text = nil;
			break;
	}
	
	return cell;
}

@end
