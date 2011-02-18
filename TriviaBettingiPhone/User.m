// 
//  User.m
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "DataModel.h"

@implementation User 

@dynamic oauth;
@dynamic username;
@dynamic credits;

+ (User *) getUser {
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity  = [NSEntityDescription entityForName:@"User" 
											   inManagedObjectContext:[[DataModel getInstance] managedObjectContext]];
	[request setEntity:entity];
	
	NSArray *array = [[[DataModel getInstance] managedObjectContext] executeFetchRequest:request error:nil];
	
	if(array == nil || [array count] == 0) {
		User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" 
															 inManagedObjectContext:[[DataModel getInstance] managedObjectContext]];
		return user;
	} else {
		return [array objectAtIndex:0];
	}
}

@end
