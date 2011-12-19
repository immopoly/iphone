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

@synthesize hello;
@synthesize bank;
@synthesize miete;
@synthesize provision;
@synthesize loginCheck;
@synthesize spinner;
@synthesize labelBank;
@synthesize labelMiete;
@synthesize labelProvision;
@synthesize badgesViewClosed;
@synthesize badgesView;
@synthesize showBadgesButton;
@synthesize badgeImages;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"User", @"Third");
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_user"];
        self.loginCheck = [[LoginCheck alloc] init];
        self.badgesViewClosed = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideLabels: YES];
    [spinner startAnimating];
    [badgesView setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    loginCheck.delegate = self;
    [loginCheck checkUserLogin];
    [super viewDidAppear:animated];
}

-(void)hideLabels:(BOOL)_hidden {
    [hello setHidden: _hidden];
    [bank setHidden: _hidden];
    [miete setHidden: _hidden];
    [provision setHidden: _hidden];
    [labelBank setHidden: _hidden];
    [labelMiete setHidden: _hidden];
    [labelProvision setHidden: _hidden];
}

- (void)stopSpinnerAnimation {
    [spinner stopAnimating];
    [spinner setHidden: YES];
}

-(NSString*) formatToCurrencyWithNumber:(double)number {
    NSLocale *german = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"]; 
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:german];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    return [numberFormatter stringFromNumber: [NSNumber numberWithDouble: number]];
}

- (void)performActionAfterLoginCheck {
    
    ImmopolyUser *myUser = [[ImmopolyManager instance] user];
    
    [hello setText: [NSString stringWithFormat: @"Hello, %@!", [myUser userName]]];
    [bank setText: [self formatToCurrencyWithNumber:[myUser balance]]];
    [miete setText: [self formatToCurrencyWithNumber:[myUser lastRent]]];
    [provision setText: [self formatToCurrencyWithNumber:[myUser lastProvision]]];
    
    [self stopSpinnerAnimation];
    [self hideLabels: NO];
    [self.badgesView setHidden:[[myUser badges] count] == 0];
    [[self.badgeImages objectAtIndex:0] setImage:[UIImage imageNamed:@"immopoly.png"]];
}

- (void)viewDidUnload {
    [super viewDidUnload];  
    
    self.hello = nil;
    self.bank = nil;
    self.miete = nil;
    self.provision = nil;
    self.labelBank = nil;
    self.labelMiete = nil;
    self.labelProvision = nil;
    self.spinner = nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)toggleBadgesView {
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	CGPoint posBadgesView = badgesView.center;
    if (self.badgesViewClosed) {
        posBadgesView.y = 310.0f;
        self.badgesViewClosed = NO;
        [showBadgesButton setTitle:@"weniger anzeigen" forState:UIControlStateNormal];
    }
    else {
        posBadgesView.y = 390.0f;
        self.badgesViewClosed = YES;
        [showBadgesButton setTitle:@"mehr anzeigen" forState:UIControlStateNormal];
    }
	
    badgesView.center = posBadgesView;
    [UIView commitAnimations];
}

-(void) dealloc {
    [hello release];
    [bank release];
    [miete release];
    [provision release];
    [labelBank release];
    [labelMiete release];
    [labelProvision release];
    [loginCheck release];
    [spinner release];
    [badgesView release];
    [showBadgesButton release];
    [badgeImages release];
    [super dealloc];
}

@end
