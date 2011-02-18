//
//  PuzzleViewController.m
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PuzzleViewController.h"


@implementation PuzzleViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (id) initWithPuzzle:(Puzzle *) p {
	self = [super init];
	puzzle = p;
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	puzzleName.text = puzzle.name;
	puzzleDescription.text = puzzle.puzzleDescription;
	if([puzzle.questions count] > 0) {
		questionsLabel.text = [NSString stringWithFormat:@"%d Questions", [puzzle.questions count]];
	} else {
		questionsLabel.text = @"This puzzle has no questions";
	}
	if(puzzle.lastPlayed != nil) {
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MM/dd/YYYY"];
		lastPlayedLabel.text = [NSString stringWithFormat:@"Last played on %@ Score: %d", [format stringFromDate:puzzle.lastPlayed], [puzzle.creditDelta intValue]];
		[format release];
	} else {
		lastPlayedLabel.text = @"Not played yet";
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction) playPuzzle:(id) sender {
	
}

- (void) setPuzzle:(Puzzle *) p {
	puzzle = p;
}


- (void)dealloc {
    [super dealloc];
}


@end
