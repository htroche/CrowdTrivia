// 
//  Question.m
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Question.h"
#import "DataModel.h"

@implementation Question 

@dynamic correctAnswer;
@dynamic answer4;
@dynamic question;
@dynamic answer2;
@dynamic answer1;
@dynamic answer3;
@dynamic difficulty;
@dynamic puzzle;
@dynamic a1;

+ (Question *) getNewQuestion {
	Question *question = [NSEntityDescription insertNewObjectForEntityForName:@"Question" 
												   inManagedObjectContext:[[DataModel getInstance] managedObjectContext]];
	return question;
}

@end
