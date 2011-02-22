//
//  PuzzlesViewController.h
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Puzzle.h"
#import "PuzzleParser.h"

@interface PuzzlesViewController : UIViewController <UIScrollViewDelegate, PuzzleParserDelegate>  {
	IBOutlet UIPageControl *pageControl;
	IBOutlet UIScrollView *scrollView;
	NSArray *puzzles;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	IBOutlet UILabel *buttonLabel;
	IBOutlet UILabel *statusLabel;
}

- (void) setupPage;
- (IBAction) pageChanged:(id) sender;
- (void) pageChangedAnimated:(id)sender animated:(BOOL) animated;
- (IBAction) closeScreen;
- (IBAction) playButtonPressed:(id) sender;
- (void) setupButtonLabel;
- (BOOL) hasInternetConnection;

@end
