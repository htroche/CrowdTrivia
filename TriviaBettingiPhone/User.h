//
//  User.h
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PersistentData.h"

@interface User :  PersistentData  
{
}

@property (nonatomic, retain) NSString * oauth;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * credits;

+ (User *) getUser;

@end



