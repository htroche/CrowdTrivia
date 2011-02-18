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
#import "PuzzleParser.h"
#import "QuestionParser.h"

@implementation Puzzle 

@dynamic creditDelta;
@dynamic locked;
@dynamic name;
@dynamic puzzleDescription;
@dynamic serverID;
@dynamic questions;

+ (Puzzle *) getNewPuzzle {
	Puzzle *puzzle = [NSEntityDescription insertNewObjectForEntityForName:@"Puzzle" 
													 inManagedObjectContext:[[DataModel getInstance] managedObjectContext]];
	return puzzle;
}

+ (NSArray *) getAllPuzzles {
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity  = [NSEntityDescription entityForName:@"Puzzle" 
											   inManagedObjectContext:[[DataModel getInstance] managedObjectContext]];
	[request setEntity:entity];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	[sortDescriptor release];
	
	
	NSArray *array = [[[DataModel getInstance] managedObjectContext] executeFetchRequest:request error:nil];
	return array;
	
}

+ (void) getServerPuzzles {
	PuzzleParser *parser = [[PuzzleParser alloc] init];
	[parser getRemotePuzzles];
	[parser release];
}

- (void) getServerQuestions {
	QuestionParser *parser = [[QuestionParser alloc] init];
	[parser getRemoteQuestions:self];
	[parser release];
}

@end
