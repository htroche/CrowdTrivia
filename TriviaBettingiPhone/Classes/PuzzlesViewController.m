//
//  PuzzlesViewController.m
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PuzzlesViewController.h"
#import "PuzzleViewController.h"
#import "Game.h"
#import "Question.h"

@implementation PuzzlesViewController

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


- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupPage];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void) setupPage {
	puzzles = [Puzzle getAllPuzzles];
	if(puzzles == nil || [puzzles count] == 0) {
		[Puzzle getServerPuzzles];
		puzzles = [Puzzle getAllPuzzles];
		for(int n = 0; n < [puzzles count]; n++) {
			Puzzle *p = [puzzles objectAtIndex:n];
			[p getServerQuestions];
		}
	}
	[puzzles retain];
	scrollView.delegate = self;
	
	[scrollView setBackgroundColor:[UIColor blackColor]];
	[scrollView setCanCancelContentTouches:NO];
	
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
	
	NSUInteger nPuzzle = 0;
	CGFloat cx = 0;
	CGRect initialRect = scrollView.frame;
	CGFloat height = initialRect.size.height;
	CGFloat width = initialRect.size.width;
	for (; nPuzzle < [puzzles count]; nPuzzle++) {
		Puzzle *p = [puzzles objectAtIndex:nPuzzle];
		PuzzleViewController *controller = [[PuzzleViewController alloc] initWithPuzzle:p];
		CGRect rect = initialRect;
		//rect.size.height = height;
		//rect.size.width = width;
		rect.origin.x = ((scrollView.frame.size.width - width) / 2) + cx;
		rect.origin.y = ((scrollView.frame.size.height - height) / 2);
		controller.view.frame = rect;
		controller.view.userInteractionEnabled = YES;
		[scrollView addSubview:controller.view];
		[controller release];
		
		cx += scrollView.frame.size.width;
	}
	
	pageControl.numberOfPages = nPuzzle;
	[scrollView setContentSize:CGSizeMake(cx, [scrollView bounds].size.height)];
	
}

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

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;	
    pageControl.currentPage = page;
}

- (void) pageChanged:(id) sender {
	[self pageChangedAnimated:sender animated:YES];
}

- (void) pageChangedAnimated:(id)sender animated:(BOOL) animated {
	CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:animated];
}

- (IBAction) closeScreen {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) playButtonPressed:(id) sender {
	Game *game = [Game getGame];
	Puzzle *p = [puzzles objectAtIndex:pageControl.currentPage];
	p.lastPlayed = [NSDate date];
	game.puzzle = p;
	NSArray *questions = [p.questions allObjects];
	game.question = [questions objectAtIndex:0];
	game.timeLeft = [NSNumber numberWithInt:30];
	game.questionIndex = [NSNumber numberWithInt:0];
	NSError *error;
	[game save:error];
	[self closeScreen];
}

- (void)dealloc {
	[puzzles release];
    [super dealloc];
}


@end
