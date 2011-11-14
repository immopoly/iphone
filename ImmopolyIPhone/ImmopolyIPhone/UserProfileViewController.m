//
//  UserProfileViewController.m
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 30.10.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import "UserProfileViewController.h"
#import "ImmopolyManager.h"
#import "ImmopolyUser.h"
#import "LoginViewController.h"

@implementation UserProfileViewController

@synthesize hello, bank, miete, provision, loginCheck;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"User", @"Third");
        self.tabBarItem.image = [UIImage imageNamed:@"tab_user"];
        self.loginCheck = [[LoginCheck alloc] init];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    loginCheck.delegate = self;
    [loginCheck checkUserLogin];
}

-(void) displayUserData {
    
    ImmopolyUser *myUser = [[ImmopolyManager instance] user];
    
    [hello setText: [NSString stringWithFormat: @"Hello, %@!", [myUser userName]]];
    [bank setText: [NSString stringWithFormat: @"%.2f", [myUser balance]]];
    [miete setText: [NSString stringWithFormat: @"%.2f", [myUser lastRent]]];
    [provision setText: [NSString stringWithFormat: @"%.2f", [myUser lastProvision]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc {
    [hello release];
    [bank release];
    [miete release];
    [provision release];
    [loginCheck release];
    [super dealloc];
}

@end
