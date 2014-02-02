//
//  IP4Settings.h
//  iP4
//
//  Created by Yoann Gini on 25/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IP4Settings : UIViewController <UITableViewDataSource> {
	UITableView	*_tableView;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end


