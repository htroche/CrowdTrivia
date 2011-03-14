//
//  TriviaBettingiPhoneViewController.m
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TriviaBettingiPhoneViewController.h"
#import "PuzzlesViewController.h"
#import "Game.h"
#import "Question.h"
#import "AdWhirlView.h"

static NSString* kAppId = @"136114726451991";

@implementation TriviaBettingiPhoneViewController

@synthesize facebook;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



- (void)viewDidLoad {
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserverForName:@"creditsChange" object:nil queue:nil usingBlock:^(NSNotification *arg1) {
		Game *game = [Game getGame];
		int credits = [game.credits intValue];
		creditsLabel.text = [NSString stringWithFormat:@"%d", credits];
	}];
	AdWhirlView *awView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
	[self.view addSubview:awView];
	pauseMode = NO;
	UIFont *font = [UIFont fontWithName:@"American Typewriter" size:14.0];
	question.font = font;
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	Game *game = [Game getGame];
	if(game == nil) {
		[self selectCategoryPressed:nil];
		return;
	}
	if(game.puzzle == nil) {
		[self selectCategoryPressed:nil];
		return;
	}
	if(game.question == nil) {
		NSArray *questions = [game.puzzle.questions allObjects];
		game.question = [questions objectAtIndex:0];
		[game save:nil];
	}
	[self setupQuestion];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (IBAction) selectCategoryPressed:(id) sender {
	//Game *game = [Game getGame];
	//NSError *error;
	//[game save:error];
	PuzzlesViewController *controller = [[PuzzlesViewController alloc] init];
	[self presentModalViewController:controller animated:YES];
	AdWhirlView *awView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
	[controller.view addSubview:awView];
	[controller release];
	[timer invalidate];
}

- (IBAction) answer1Pressed:(id) sender {
	Game *game = [Game getGame];
	if([game.question.correctAnswer intValue] == 1) {
		[self correctAnswer];
	} else {
		[self wrongAnswer];
	}
}

- (IBAction) answer2Pressed:(id) sender {
	Game *game = [Game getGame];
	if([game.question.correctAnswer intValue] == 2) {
		[self correctAnswer];
	} else {
		[self wrongAnswer];
	}
}

- (IBAction) answer3Pressed:(id) sender {
	Game *game = [Game getGame];
	if([game.question.correctAnswer intValue] == 3) {
		[self correctAnswer];
	} else {
		[self wrongAnswer];
	}
}

- (IBAction) answer4Pressed:(id) sender {
	Game *game = [Game getGame];
	if([game.question.correctAnswer intValue] == 4) {
		[self correctAnswer];
	} else {
		[self wrongAnswer];
	}
}

- (void) correctAnswer {
	[self colorAnswers];
	int points = [betLabel.text intValue];
	Game *game = [Game getGame];
	[game changeCredits:points];
	if([game isLastQuestion]) {
		[self puzzleFinished];
		return;
	}
	[timer invalidate];
	NSLog(@"question index: %@", game.questionIndex);
	UIActionSheet *laserActionSheet = [[UIActionSheet alloc] initWithTitle:@"Correct Answer" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    [laserActionSheet addButtonWithTitle:@"Next"];
	[laserActionSheet showInView:self.view];
}

- (void) wrongAnswer {
	[self colorAnswers];
	Game *game = [Game getGame];
	if([game isLastQuestion]) {
		[self puzzleFinished];
		return;
	}
	[timer invalidate];
	NSLog(@"question index: %@", game.questionIndex);
	UIActionSheet *laserActionSheet = [[UIActionSheet alloc] initWithTitle:@"Wrong Answer" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    [laserActionSheet addButtonWithTitle:@"Next"];
	[laserActionSheet showInView:self.view];
}

- (void) timeOut {
	[self colorAnswers];
	Game *game = [Game getGame];
	if([game isLastQuestion]) {
		[self puzzleFinished];
		return;
	}
	[timer invalidate];
	UIActionSheet *laserActionSheet = [[UIActionSheet alloc] initWithTitle:@"Out of Time" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    [laserActionSheet addButtonWithTitle:@"Next"];
	[laserActionSheet showInView:self.view];
}

- (void) puzzleFinished {
	[timer invalidate];
	Game *game = [Game getGame];
	game.puzzle.creditDelta = [NSNumber numberWithInt:[creditsLabel.text intValue]];
	game.credits = [NSNumber numberWithInt:0];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quiz completed" message:[NSString stringWithFormat:@"You have completed this quiz. Your score is %@", creditsLabel.text] delegate:self cancelButtonTitle:@"Play Another Quiz" otherButtonTitles:nil];
	[alert show];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex == 0) {
		betLabel.text = @"100";
		timerLabel.text = @"30";
		[self setupQuestion];
		
	}
	if(buttonIndex == 1) {
		[self resetBoard];
	}
	[actionSheet release];
}

- (void) downClock:(NSTimer *) t {
	if(pauseMode)
		return;
	int timeLeft = [timerLabel.text intValue];
	timeLeft--;
	timerLabel.text = [NSString stringWithFormat:@"%d", timeLeft];
	if(timeLeft > 25) {
		betLabel.text = [NSString stringWithFormat:@"%d", 100];
	}
	else if(timeLeft > 20) {
		betLabel.text = [NSString stringWithFormat:@"%d", 75];
	}
	else if(timeLeft > 15) {
		betLabel.text = [NSString stringWithFormat:@"%d", 50];
	}
	else if(timeLeft > 10) {
		betLabel.text = [NSString stringWithFormat:@"%d", 25];
	} 
	else if(timeLeft > 5) {
		betLabel.text = [NSString stringWithFormat:@"%d", 10];
	}
	else {
		betLabel.text = [NSString stringWithFormat:@"%d", 5];
	}
	
	if(timeLeft == 0) {
		betLabel.text = [NSString stringWithFormat:@"%d", 0];
		[timer invalidate];
		[self timeOut];
	}
}

- (void) setupQuestion {	
	Game *game = [Game getGame];
	[game nextQuestion];
	question.text = game.question.question;
	answer1Label.text = game.question.answer1;
	answer2Label.text = game.question.answer2;
	answer3Label.text = game.question.answer3;
	answer4Label.text = game.question.answer4;
	[self resetBoard];
}

- (void) resetBoard {
	answer1Label.textColor = [UIColor whiteColor];
	answer2Label.textColor = [UIColor whiteColor];
	answer3Label.textColor = [UIColor whiteColor];
	answer4Label.textColor = [UIColor whiteColor];
	betLabel.text = @"100";
	timerLabel.text = @"30";
	timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(downClock:) userInfo:nil repeats:YES];
}

- (void) colorAnswers {
	Game *game = [Game getGame];
	answer1Label.textColor = [UIColor redColor];
	answer2Label.textColor = [UIColor redColor];
	answer3Label.textColor = [UIColor redColor];
	answer4Label.textColor = [UIColor redColor];
	if([game.question.correctAnswer intValue] == 1)
		answer1Label.textColor = [UIColor greenColor];
	if([game.question.correctAnswer intValue] == 2)
		answer2Label.textColor = [UIColor greenColor];
	if([game.question.correctAnswer intValue] == 3)
		answer3Label.textColor = [UIColor greenColor];
	if([game.question.correctAnswer intValue] == 4)
		answer4Label.textColor = [UIColor greenColor];
}

- (IBAction) facebookPressed:(id) sender {
	NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
	NSDate *expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"token_expiration"];
	if(self.facebook == nil)
		self.facebook = [[Facebook alloc] initWithAppId:kAppId];
	if(accessToken == nil) {
		NSArray *permissions =  [NSArray arrayWithObjects:
						 @"read_stream", @"offline_access", @"publish_stream", nil];
		[self.facebook authorize:permissions delegate:self];
	} else {
		self.facebook.accessToken = accessToken;
		self.facebook.expirationDate = expirationDate;
		//[self.facebook requestWithGraphPath:@"me" andDelegate:self];
		NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
		NSMutableString *message = [NSMutableString stringWithCapacity:10];
		Game *game = [Game getGame];
		[message appendString:game.question.question];
		[message appendFormat:@"\n  %@", game.question.answer1];
		[message appendFormat:@"\n  %@", game.question.answer2];
		[message appendFormat:@"\n  %@", game.question.answer3];
		[message appendFormat:@"\n  %@", game.question.answer4];
		[params setObject:message forKey:@"message"];
		[params setObject:@"www.crowdtrivia.com" forKey:@"link"];
		[params setObject:@"Help me with this question!" forKey:@"description"];
		[params setObject:@"name" forKey:@"name"];
		[self.facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
	}
}

- (void)fbDidLogin {
	[[NSUserDefaults standardUserDefaults] setObject:self.facebook.accessToken forKey:@"access_token"];
	[[NSUserDefaults standardUserDefaults] setObject:self.facebook.expirationDate forKey:@"token_expiration"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
}

- (void)fbDidNotLogin:(BOOL)cancelled {
}


- (void)fbDidLogout {
}

- (void)fbDialogLogin:(NSString*)token expirationDate:(NSDate*)expirationDate {
	[[NSUserDefaults standardUserDefaults] setObject:token forKey:@"access_token"];
	[[NSUserDefaults standardUserDefaults] setObject:expirationDate forKey:@"token_expiration"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)fbDialogNotLogin:(BOOL)cancelled {
}

- (void)requestLoading:(FBRequest *)request {
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"Error: %@", [error description]);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
	if ([result isKindOfClass:[NSArray class]]) {
		result = [result objectAtIndex:0];
	}
	NSLog(@"name: %@ id: %@", [result objectForKey:@"name"], [result objectForKey:@"id"]);
}

- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data {
}

- (void)alertView:(UIAlertView  *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	PuzzlesViewController *controller = [[PuzzlesViewController alloc] init];
	[self presentModalViewController:controller animated:YES];
	[controller release];
	Game *game = [Game getGame];
	[game resetPuzzle];
	[alertView release];
}

- (NSString *)adWhirlApplicationKey {
	return @"90df21e453734c0fb2ad474b1f2434c7";
}

- (UIViewController *)viewControllerForPresentingModalView {
	return self;
}

- (void)adWhirlWillPresentFullScreenModal {
	[self pauseGame:YES];
}

- (void)adWhirlDidDismissFullScreenModal {
	[self pauseGame:NO];
}

- (void) pauseGame:(BOOL) pause {
	pauseMode = pause;
}

- (void)dealloc {
    [super dealloc];
}

@end
