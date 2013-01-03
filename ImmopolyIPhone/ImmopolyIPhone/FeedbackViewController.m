//
//  FeedbackViewController.m
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 15.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FeedbackViewController.h"
#import "Constants.h"
#import "UIDevice+Resolutions.h"

@implementation FeedbackViewController

@synthesize sendMailButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Feedback", @"Second");
        [[self tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_icon_feedback"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_icon_feedback"]];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 42; // top navigation view
    frame.size.height -= 20; // status bar
    frame.size.height -= 49; // tabbar
    self.view.frame = frame;
    
    if ([[UIDevice currentDevice] resolution] == UIDeviceResolution_iPhoneRetina4) {
        [self.backgroundImageView setImage:[UIImage imageNamed:@"background_envelope_568h@2x.png"]];
    } else {
        [self.backgroundImageView setImage:[UIImage imageNamed:@"background_envelope.png"]];
    }
    frame.origin.y = 42;
    [self.backgroundImageView setFrame:frame];
    
    CGRect buttonFrame = self.sendMailButton.frame;
    buttonFrame.origin.y = self.view.frame.size.height - 20;
    [self.sendMailButton setFrame:buttonFrame];
    
    [super.spinner setHidden:YES];
    
    // setting the text of the helperView
    [super initHelperViewWithMode:INFO_FEEDBACK];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.sendMailButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)sendMail {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
    
    NSArray *recipients = [NSArray arrayWithObject:@"immopoly-devs@googlegroups.com"];
    [controller setToRecipients:recipients];
	[controller setSubject:feedbackMailSubject];
	
    if (controller) [self presentModalViewController:controller animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}

@end
