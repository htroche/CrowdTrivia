//
//  Game.h
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define CREDITS_CHANGE @"creditsChange"

#import <CoreData/CoreData.h>
#import "PersistentData.h"

@class Puzzle;
@class Question;

@interface Game :  PersistentData  
{
	NSArray *questions;
}

@property (nonatomic, retain) NSNumber * timeLeft;
@property (nonatomic, retain) NSNumber * credits;
@property (nonatomic, retain) NSNumber * questionIndex;
@property (nonatomic, retain) Question * question;
@property (nonatomic, retain) Puzzle * puzzle;


+ (Game *) getGame;

- (void) changeCredits:(int) delta;
- (void) bet:(int) bet;
- (void) winBet:(int) bet;
- (Question *) nextQuestion;
- (void) resetPuzzle;
- (BOOL) isLastQuestion;

@end



