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

@interface QuestionParser : NSObject <NSXMLParserDelegate> {
	Puzzle *puzzle;
	Question *currentQuestion;
	NSString *currentElement;
	NSString *trimmedString;
}

@property (nonatomic, retain) NSString * currentElement;

- (void) getRemoteQuestions:(Puzzle *) p;
- (NSData *) getQuestions:(NSError *) error;

@end
