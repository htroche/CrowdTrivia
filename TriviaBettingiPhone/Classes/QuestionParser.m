//
//  QuestionParser.m
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QuestionParser.h"


@implementation QuestionParser

@synthesize currentElement;

- (void) getRemoteQuestions:(Puzzle *) p delegate:(<PuzzleParserDelegate>) d {
	receivedData = [NSMutableData dataWithCapacity:30];
	[receivedData retain];
	delegate = d;
	puzzle = p;
	[self getQuestions:nil];
}

- (void) getQuestions:(NSError *) error {
	NSString *url = [NSString stringWithFormat:@"http://crowdtrivia.heroku.com/puzzles/%@/questions.xml", puzzle.serverID];
	NSLog(@"URL: %@", url);
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
															  cachePolicy:NSURLRequestReloadIgnoringCacheData
														  timeoutInterval:60.0];
	[theRequest setHTTPMethod:@"GET"];
	[theRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
	[NSURLConnection connectionWithRequest:theRequest delegate:self];
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError  *)error {
	[delegate setStatusMessage:@"No internet connection"];
	//[delegate finishedQuestions];
	[delegate fetchError];
	[receivedData release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData  *)data {
    [receivedData appendData:data];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	self.currentElement = elementName;
	if([elementName isEqualToString:@"question"] && currentQuestion == nil) {
		currentQuestion = [Question getNewQuestion];
		currentQuestion.puzzle = puzzle;
	}
	
}

- (void)parser:(NSXMLParser  *)parser didEndElement:(NSString  *)elementName namespaceURI:(NSString  *)namespaceURI qualifiedName:(NSString  *)qName {
	if([elementName isEqualToString:@"question"]) {
		if(currentQuestion != nil) {
			[currentQuestion save:nil];
			currentQuestion = nil;
		}
		
	}
}

- (void)parser:(NSXMLParser  *)parser foundCharacters:(NSString  *)string {
	trimmedString = [string stringByTrimmingCharactersInSet:
							   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([trimmedString length] >= 1 && currentQuestion != nil) {
		if([self.currentElement isEqualToString:@"answer1"])
			currentQuestion.answer1 = trimmedString;
		if([self.currentElement isEqualToString:@"answer2"])
			currentQuestion.answer2 = trimmedString;
		if([self.currentElement isEqualToString:@"answer3"])
			currentQuestion.answer3 = trimmedString;
		if([self.currentElement isEqualToString:@"answer4"])
			currentQuestion.answer4 = trimmedString;
		if([self.currentElement isEqualToString:@"quiz-question"])
			currentQuestion.question = trimmedString;
		if([self.currentElement isEqualToString:@"correct-answer"])
			currentQuestion.correctAnswer = [NSNumber numberWithInt:[trimmedString intValue]];
		if([self.currentElement isEqualToString:@"difficulty"])
			currentQuestion.difficulty = [NSNumber numberWithInt:[trimmedString intValue]];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[delegate setStatusMessage:@"Getting questions..."];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:receivedData];
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
	[delegate finishedQuestions];
	[receivedData release];
}


@end
