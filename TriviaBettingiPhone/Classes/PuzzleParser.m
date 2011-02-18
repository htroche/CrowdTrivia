//
//  PuzzleParser.m
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PuzzleParser.h"


@implementation PuzzleParser

@synthesize currentElement;

- (void) getRemotePuzzles {
	NSData *xmlData = [self getPuzzles:nil];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	self.currentElement = elementName;
	if([elementName isEqualToString:@"puzzle"]) {
		currentPuzzle = [Puzzle getNewPuzzle];
	}
	
}

- (void)parser:(NSXMLParser  *)parser didEndElement:(NSString  *)elementName namespaceURI:(NSString  *)namespaceURI qualifiedName:(NSString  *)qName {
	if([elementName isEqualToString:@"puzzle"]) {
		if(currentPuzzle != nil) {
			[currentPuzzle save:nil];
			currentPuzzle = nil;
		}
		
	}
}

- (void)parser:(NSXMLParser  *)parser foundCharacters:(NSString  *)string {
	NSString *trimmedString = [string stringByTrimmingCharactersInSet:
							   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([trimmedString length] >= 1 && currentPuzzle != nil) {
		if([self.currentElement isEqualToString:@"name"])
			currentPuzzle.name = trimmedString;
		if([self.currentElement isEqualToString:@"description"])
			currentPuzzle.puzzleDescription = trimmedString;
		if([self.currentElement isEqualToString:@"id"])
			currentPuzzle.serverID = trimmedString;
	}
}

- (NSData *) getPuzzles:(NSError *) error {
	
	NSString *url = @"http://triviabetting.heroku.com/puzzles.xml";
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
															  cachePolicy:NSURLRequestReloadIgnoringCacheData
														  timeoutInterval:60.0];
	[theRequest setHTTPMethod:@"GET"];
	[theRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
	NSURLResponse *theResponse = NULL;
	NSData *theResponseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];
	NSString *s = [[NSString alloc] initWithData:theResponseData encoding:NSUTF8StringEncoding];
	[s release];
	return theResponseData;
	
}

@end
