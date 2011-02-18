//
//  PuzzleParser.h
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Puzzle.h";

@interface PuzzleParser : NSObject <NSXMLParserDelegate> {
	NSString *currentElement;
	Puzzle *currentPuzzle;
}

@property (nonatomic, retain) NSString * currentElement;

- (void) getRemotePuzzles;
- (NSData *) getPuzzles:(NSError *) error;

@end
