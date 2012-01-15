//
//  FeedbackViewController.h
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 15.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface FeedbackViewController : AbstractViewController <MFMailComposeViewControllerDelegate> {
}

- (IBAction)sendMail;

@end
