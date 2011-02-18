//
//  PersistentData.h
//  iPhoneChargeCapture
//
//  Created by Hugo Troche on 10/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PersistentData : NSManagedObject {

}

- (void) save:(NSError *) error;
- (void) deleteObject:(NSError *) error;
- (void) refresh;

@end
