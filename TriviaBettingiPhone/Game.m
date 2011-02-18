// 
//  Game.m
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Game.h"

#import "Puzzle.h"
#import "Question.h"
#import "DataModel.h"

@implementation Game 

@dynamic timeLeft;
@dynamic credits;
@dynamic questionIndex;
@dynamic question;
@dynamic puzzle;

+ (Game *) getGame {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity  = [NSEntityDescription entityForName:@"Game" 
											   inManagedObjectContext:[[DataModel getInstance] managedObjectContext]];
	[request setEntity:entity];
	NSArray *array = [[[DataModel getInstance] managedObjectContext] executeFetchRequest:request error:nil];
	[request release];						   
	if(array == nil || [array count] == 0) {
		Game *game = [NSEntityDescription insertNewObjectForEntityForName:@"Game" 
															 inManagedObjectContext:[[DataModel getInstance] managedObjectContext]];
		return game;
	} else {
		return [array objectAtIndex:0];
	}
}

- (void) changeCredits:(int) delta {
	int c = [self.credits intValue];
	int result = c + delta;
	self.credits = [NSNumber numberWithInt:result];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"creditsChange" object:self];
	[self save:nil];
}

- (void) bet:(int) bet {
	[self changeCredits:-1*bet];
}

- (void) winBet:(int) bet {
	[self changeCredits:2*bet];
}

- (Question *) nextQuestion {
	questions = [self.puzzle.questions allObjects];
	[questions retain];
	int index = [self.questionIndex intValue];
	NSLog(@"index: %d count: %d", index, [questions count]);
	if(index >= [questions count]) {
		return nil;
	}
	self.question = [questions objectAtIndex:index];
	index++;
	self.questionIndex = [NSNumber numberWithInt:index];
	NSError *error;
	[self save:error];
	return self.question;
}

- (void) resetPuzzle {
	self.questionIndex = [NSNumber numberWithInt:0];
	[questions release];
}

- (BOOL) isLastQuestion {
	return ([self.questionIndex intValue] >= [self.puzzle.questions count]);
}

@end
