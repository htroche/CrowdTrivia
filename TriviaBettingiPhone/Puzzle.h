//
//  Puzzle.h
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PersistentData.h"

@class Question;

@interface Puzzle :  PersistentData  
{

}

@property (nonatomic, retain) NSNumber * creditDelta;
@property (nonatomic, retain) NSNumber * locked;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * puzzleDescription;
@property (nonatomic, retain) NSString * serverID;
@property (nonatomic, retain) NSDate * lastPlayed;
@property (nonatomic, retain) NSSet* questions;


+ (Puzzle *) getNewPuzzle;
+ (NSArray *) getAllPuzzles;
+ (void) getServerPuzzles;

- (void) getServerQuestions;


@end


@interface Puzzle (CoreDataGeneratedAccessors)
- (void)addQuestionsObject:(Question *)value;
- (void)removeQuestionsObject:(Question *)value;
- (void)addQuestions:(NSSet *)value;
- (void)removeQuestions:(NSSet *)value;

@end

