//
//  IPMusic.h
//  iPlayer
//
//  Created by Yoann Gini on 31/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface IPMusic :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * album;
@property (nonatomic, retain) NSNumber * isPlayed;

@end



