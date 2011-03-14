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
#import "MorePuzzlesViewController.h"
#import "Reachability.h"

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
	puzzles = [Puzzle getAllPuzzles:nil];
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
	
	MorePuzzlesViewController *controller = [[MorePuzzlesViewController alloc] init];
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
	
	pageControl.numberOfPages = (nPuzzle + 1);
	[scrollView setContentSize:CGSizeMake(cx, [scrollView bounds].size.height)];
	[self setupButtonLabel];
	
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
	[self setupButtonLabel];
}

- (void) pageChanged:(id) sender {
	[self pageChangedAnimated:sender animated:YES];
}

- (void) pageChangedAnimated:(id)sender animated:(BOOL) animated {
	CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:animated];
	[self setupButtonLabel];
}

- (void) setupButtonLabel {
	if((pageControl.currentPage + 1) == pageControl.numberOfPages) {
		buttonLabel.text = @"Get more";
	} else {
		buttonLabel.text = @"Play";
	}
}

- (IBAction) closeScreen {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) playButtonPressed:(id) sender {
	if((pageControl.currentPage + 1) == pageControl.numberOfPages) {
		if([self hasInternetConnection]) {
			[Puzzle getServerPuzzles:self];
			[activityIndicator startAnimating];
		} else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"You need an internet connection to get more quizzes." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
		return;
	}
	Game *game = [Game getGame];
	if(game == nil) {
		game = [Game getNewGame];
	}
	Puzzle *p = [puzzles objectAtIndex:pageControl.currentPage];
	p.lastPlayed = [NSDate date];
	game.puzzle = p;
	NSArray *questions = [p.questions allObjects];
	if([questions count] == 0) {
		[activityIndicator startAnimating];
		[self setStatusMessage:@"Getting questions..."];
		[p getServerQuestions:self];
		return;
	} else {
		game.question = [questions objectAtIndex:0];
		game.timeLeft = [NSNumber numberWithInt:30];
		game.questionIndex = [NSNumber numberWithInt:0];
		game.credits = [NSNumber numberWithInt:0];
		NSError *error;
		[game save:error];
		[self closeScreen];
	}
}

- (void)alertView:(UIAlertView  *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[alertView release];
}

- (void) setStatusMessage:(NSString *) message {
	statusLabel.hidden = NO;
	statusLabel.text = message;
}

- (void) finishedPuzzles {
	NSDate *since = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUpdated"];
	puzzles = [Puzzle getAllPuzzles:since];
	statusLabel.hidden = YES;
	[activityIndicator stopAnimating];
	[self setupPage];
	
}

- (void) finishedQuestions {
	statusLabel.hidden = YES;
	[activityIndicator stopAnimating];
	Game *game = [Game getGame];
	if(game == nil) {
		game = [Game getNewGame];
	}
	Puzzle *p = [puzzles objectAtIndex:pageControl.currentPage];
	p.lastPlayed = [NSDate date];
	game.puzzle = p;
	NSArray *questions = [p.questions allObjects];
	game.question = [questions objectAtIndex:0];
	game.timeLeft = [NSNumber numberWithInt:30];
	game.questionIndex = [NSNumber numberWithInt:0];
	game.credits = [NSNumber numberWithInt:0];
	NSError *error;
	[game save:error];
	[self closeScreen];
}

- (void) fetchError {
	[activityIndicator stopAnimating];
}

- (void) finishedMessage:(NSString *)message {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Finished" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

- (BOOL) hasInternetConnection {
	Reachability *r = [Reachability reachabilityForInternetConnection];
	return ([r currentReachabilityStatus] != NotReachable);
}

- (void)dealloc {
	[puzzles release];
    [super dealloc];
}


@end
