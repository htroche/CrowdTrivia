//
//  PuzzlesViewController.h
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Puzzle.h"

@interface PuzzlesViewController : UIViewController <UIScrollViewDelegate>  {
	IBOutlet UIPageControl *pageControl;
	IBOutlet UIScrollView *scrollView;
	NSArray *puzzles;
}

- (void) setupPage;
- (IBAction) pageChanged:(id) sender;
- (void) pageChangedAnimated:(id)sender animated:(BOOL) animated;
- (IBAction) closeScreen;
- (IBAction) playButtonPressed:(id) sender;

@end
