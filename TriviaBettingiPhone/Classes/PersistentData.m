//
//  PersistentData.m
//  iPhoneChargeCapture
//
//  Created by Hugo Troche on 10/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PersistentData.h"
#import "DataModel.h"


@implementation PersistentData

- (void) save:(NSError *) error {
	DataModel *model = [DataModel getInstance];
	BOOL contextDidSave = [[model managedObjectContext] save:&error];
	
	if (!contextDidSave) {
		
		// If the context failed to save, log out as many details as possible.
		NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
		
		NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
		
		if (detailedErrors != nil && [detailedErrors count] > 0) {
			
			for (NSError* detailedError in detailedErrors) {
				NSLog(@"  DetailedError: %@", [detailedError userInfo]);
			}
		} else {
			NSLog(@"  %@", [error userInfo]);
		}
	}
}

- (void) deleteObject:(NSError *) error {
	DataModel *model = [DataModel getInstance];
	[[model managedObjectContext] deleteObject:self];
}

- (void) refresh {
	DataModel *model = [DataModel getInstance];
	[[model managedObjectContext] refreshObject:self mergeChanges:YES];
}

@end
