//
//  PuzzleParser.h
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Puzzle.h";

@protocol PuzzleParserDelegate

- (void) setStatusMessage:(NSString *) message;
- (void) finishedPuzzles;
- (void) finishedQuestions;
- (void) fetchError;

@end

@interface PuzzleParser : NSObject <NSXMLParserDelegate> {
	NSString *currentElement;
	Puzzle *currentPuzzle;
	<PuzzleParserDelegate> delegate;
}

@property (nonatomic, retain) NSString * currentElement;

- (void) getRemotePuzzles:(<PuzzleParserDelegate>) delegate;
- (void) getPuzzles:(NSError *) error;

@end


