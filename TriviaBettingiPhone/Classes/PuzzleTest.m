//
//  PuzzleTest.m
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PuzzleTest.h"


@implementation PuzzleTest

- (void) testGetRemotePuzzles {
	[Puzzle getServerPuzzles];
	NSArray *puzzles = [Puzzle getAllPuzzles];
	if([puzzles count] < 1) {
		STFail(@"Get server puzzles failed");
		return;
	}
	Puzzle *p = [puzzles objectAtIndex:0];
	[p getServerQuestions];
	if([p.questions count] < 1)
		STFail(@"Get server questions failed");
}

@end
