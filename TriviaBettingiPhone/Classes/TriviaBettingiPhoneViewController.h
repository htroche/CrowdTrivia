//
//  TriviaBettingiPhoneViewController.h
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define BET_DELTA 100
#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface TriviaBettingiPhoneViewController : UIViewController <UIActionSheetDelegate,FBRequestDelegate,
FBDialogDelegate,FBSessionDelegate> {
	IBOutlet UIButton *answer1;
	IBOutlet UIButton *answer2;
	IBOutlet UIButton *answer3;
	IBOutlet UIButton *answer4;
	IBOutlet UITextView *question;
	IBOutlet UILabel *timerLabel;
	IBOutlet UILabel *creditsLabel;
	IBOutlet UITextField *betLabel;
	
	IBOutlet UILabel *answer1Label;
	IBOutlet UILabel *answer2Label;
	IBOutlet UILabel *answer3Label;
	IBOutlet UILabel *answer4Label;
	
	NSTimer *timer;
	Facebook *facebook;
}

@property (nonatomic, retain) Facebook *facebook;

- (IBAction) selectCategoryPressed:(id) sender;
- (IBAction) answer1Pressed:(id) sender;
- (IBAction) answer2Pressed:(id) sender;
- (IBAction) answer3Pressed:(id) sender;
- (IBAction) answer4Pressed:(id) sender;
- (IBAction) upBetPressed:(id) sender;
- (IBAction) downBetPressed:(id) sender;
- (IBAction) facebookPressed:(id) sender;

- (void) correctAnswer;
- (void) wrongAnswer;
- (void) setupQuestion;
- (void) timeOut;
- (void) resetBoard;


@end

