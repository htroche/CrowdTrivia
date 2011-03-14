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

- (void) getRemotePuzzles:(<PuzzleParserDelegate>) d {
	receivedData = [NSMutableData dataWithCapacity:30];
	[receivedData retain];
	delegate = d;
	[self getPuzzles:nil];
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
			totalPuzzles++;
		}
		
	}
}

- (void)parser:(NSXMLParser  *)parser foundCharacters:(NSString  *)string {
	NSString *trimmedString = [string stringByTrimmingCharactersInSet:
							   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([trimmedString length] >= 1 && currentPuzzle != nil) {
		if([self.currentElement isEqualToString:@"name"]) {
			currentPuzzle.name = trimmedString;
			[delegate setStatusMessage:[NSString stringWithFormat:@"Getting %@",trimmedString]];
		}
		if([self.currentElement isEqualToString:@"description"])
			currentPuzzle.puzzleDescription = trimmedString;
		if([self.currentElement isEqualToString:@"id"])
			currentPuzzle.serverID = trimmedString;
	}
}

- (void) getPuzzles:(NSError *) error {
	[delegate setStatusMessage:@"Quizzes are coming..."];
	NSDate *since = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUpdated"];
	NSString *url = @"http://crowdtrivia.heroku.com/puzzles.xml?lastUpdated=2011-03-15T00:00:00Z";
	if(since != nil) {
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"yyyy-MM-ddTHH:mm:ssZ"];
		[format setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
		NSString *syncDate;
		syncDate = [format stringFromDate:since];
		[format release];
		url = [NSString stringWithFormat:@"http://triviabetting.heroku.com/puzzles.xml?lastUpdated=%@",syncDate];
	}
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
															  cachePolicy:NSURLRequestReloadIgnoringCacheData
														  timeoutInterval:60.0];
	[theRequest setHTTPMethod:@"GET"];
	[theRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
	[NSURLConnection connectionWithRequest:theRequest delegate:self];
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError  *)error {
	[delegate setStatusMessage:@"No internet connection"];
	//[delegate finishedPuzzles];
	[delegate fetchError];
	[delegate finishedMessage:[NSString stringWithFormat:@"Error downloading. Please try again later."]];
	[receivedData release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData  *)data {
	[receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[delegate setStatusMessage:@"Getting quizzes..."];
	totalPuzzles = 0;
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:receivedData];
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
	[delegate finishedPuzzles];
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastUpdated"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	if(totalPuzzles > 0)
		[delegate finishedMessage:[NSString stringWithFormat:@"Downloaded %d new quizzes", totalPuzzles]];
	else
		[delegate finishedMessage:[NSString stringWithFormat:@"No new quizzes to download"]];
	[receivedData release];

}

@end
