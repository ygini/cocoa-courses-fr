//
//  LightPhoneViewController.m
//  LightPhone
//
//  Created by Yoann Gini on 22/04/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "LightPhoneViewController.h"

@implementation LightPhoneViewController

-(IBAction)toggle:(UIButton*)sender {
	sender.selected = !sender.selected;
	label.text = sender.selected ? @"On" : @"Off";
}

@end
