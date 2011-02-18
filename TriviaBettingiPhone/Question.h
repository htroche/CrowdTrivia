//
//  Question.h
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PersistentData.h"
#import "Puzzle.h"

@interface Question :  PersistentData  
{
}

@property (nonatomic, retain) NSNumber * correctAnswer;
@property (nonatomic, retain) NSString * answer4;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSString * answer2;
@property (nonatomic, retain) NSString * answer1;
@property (nonatomic, retain) NSString * answer3;
@property (nonatomic, retain) NSNumber * difficulty;
@property (nonatomic, retain) Puzzle * puzzle;

@property (nonatomic, retain) NSString * a1;

+ (Question *) getNewQuestion;

@end



