//
//  PuzzleViewController.h
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Puzzle.h"

@interface PuzzleViewController : UIViewController {
	IBOutlet UILabel *puzzleName;
	IBOutlet UIImageView *puzzleIcon;
	IBOutlet UITextView *puzzleDescription;
	IBOutlet UIButton *playButton;
	IBOutlet UILabel *questionsLabel;
	IBOutlet UILabel *lastPlayedLabel;
	Puzzle *puzzle;
	
}

- (id) initWithPuzzle:(Puzzle *) p;

- (IBAction) playPuzzle:(id) sender;
- (void) setPuzzle:(Puzzle *) p;

@end
