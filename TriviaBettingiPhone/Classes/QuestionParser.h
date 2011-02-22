//
//  QuestionParser.h
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "Puzzle.h"
#import "PuzzleParser.h"

@interface QuestionParser : NSObject <NSXMLParserDelegate> {
	Puzzle *puzzle;
	Question *currentQuestion;
	NSString *currentElement;
	NSString *trimmedString;
	<PuzzleParserDelegate> delegate;
}

@property (nonatomic, retain) NSString * currentElement;

- (void) getRemoteQuestions:(Puzzle *) p delegate:(<PuzzleParserDelegate>) delegate;
- (void) getQuestions:(NSError *) error;

@end
