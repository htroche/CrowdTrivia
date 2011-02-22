// 
//  Puzzle.m
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Puzzle.h"
#import "Question.h"
#import "DataModel.h"
#import "QuestionParser.h"
#import "PuzzleParser.h"

@implementation Puzzle 

@dynamic creditDelta;
@dynamic locked;
@dynamic name;
@dynamic puzzleDescription;
@dynamic serverID;
@dynamic questions;
@dynamic lastPlayed;
@dynamic lastUpdated;

+ (Puzzle *) getNewPuzzle {
	Puzzle *puzzle = [NSEntityDescription insertNewObjectForEntityForName:@"Puzzle" 
													 inManagedObjectContext:[[DataModel getInstance] managedObjectContext]];
	return puzzle;
}

+ (NSArray *) getAllPuzzles:(NSDate *) since {
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity  = [NSEntityDescription entityForName:@"Puzzle" 
											   inManagedObjectContext:[[DataModel getInstance] managedObjectContext]];
	[request setEntity:entity];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	[sortDescriptor release];
	
	if(since != nil) {
		NSMutableString *predicateString = [NSMutableString stringWithCapacity:10];
		[predicateString appendString:@"lastUpdated > %@"];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:
								  predicateString, since];
		[request setPredicate:predicate];
	}
	
	NSArray *array = [[[DataModel getInstance] managedObjectContext] executeFetchRequest:request error:nil];
	return array;
	
}

+ (void) getServerPuzzles:(<PuzzleParserDelegate>) d {
	PuzzleParser *parser = [[PuzzleParser alloc] init];
	[parser getRemotePuzzles:d];
	[parser release];
}

- (void) getServerQuestions:(<PuzzleParserDelegate>) d {
	QuestionParser *parser = [[QuestionParser alloc] init];
	[parser getRemoteQuestions:self delegate:d];
	[parser release];
}

- (void) save:(NSError *) error {
	self.lastUpdated = [NSDate date];
	[super save:error];
}

@end
