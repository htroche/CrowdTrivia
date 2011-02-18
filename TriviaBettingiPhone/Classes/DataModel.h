//
//  DataModel.h
//  
//
//  Created by Hugo Troche on 10/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <CoreData/CoreData.h>


@interface DataModel : NSObject {
	NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

+ (DataModel *) getInstance;

- (NSManagedObjectContext *)managedObjectContext;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSString *)applicationDocumentsDirectory;


@end
