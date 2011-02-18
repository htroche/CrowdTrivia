//
//  TriviaBettingiPhoneAppDelegate.h
//  TriviaBettingiPhone
//
//  Created by Hugo Troche on 2/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TriviaBettingiPhoneViewController;

@interface TriviaBettingiPhoneAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TriviaBettingiPhoneViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TriviaBettingiPhoneViewController *viewController;

@end

