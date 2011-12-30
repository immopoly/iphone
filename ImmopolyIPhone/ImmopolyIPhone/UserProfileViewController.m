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
#import "UserBadge.h"

@implementation UserProfileViewController

@synthesize hello;
@synthesize bank;
@synthesize miete;
@synthesize numExposes;
//@synthesize loginCheck;
//@synthesize spinner;
@synthesize labelBank;
@synthesize labelMiete;
@synthesize labelNumExposes;
@synthesize badgesViewClosed;
@synthesize badgesView;
@synthesize showBadgesButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"User", @"Third");
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_user"];
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
    
    // setting the text of the helperView
    [super initHelperView];
    [super setHelperViewTitle:@"Hilfe zur Benutzeransicht"];
}


- (void)viewDidAppear:(BOOL)animated {
    [self performActionAfterLoginCheck];
    [super viewDidAppear:animated];
}

- (NSString*) formatToCurrencyWithNumber:(double)number {
    NSLocale *german = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"]; 
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:german];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    return [numberFormatter stringFromNumber: [NSNumber numberWithDouble: number]];
}

- (void)performActionAfterLoginCheck {
    
    ImmopolyUser *myUser = [[ImmopolyManager instance] user];
    
    if(myUser != nil) {
        [hello setText: [NSString stringWithFormat: @"Hello, %@!", [myUser userName]]];
        [bank setText: [self formatToCurrencyWithNumber:[myUser balance]]];
        [miete setText: [self formatToCurrencyWithNumber:[myUser lastRent]]];
        [numExposes setText: [ NSString stringWithFormat:@"%i von %i", [myUser numExposes], [myUser maxExposes]]];
        
        if([[myUser badges] count] > 0) {
            [self displayBadges];
        }
        else {
            [self.badgesView setHidden:YES];
        }
    }
}

- (void)displayBadges {
    NSArray *userBadges = [[[ImmopolyManager instance] user] badges];
    
    //Set coordinates for badges. Shall be implemented in a more smart way later..
    NSMutableArray *imageCoordinates = [NSMutableArray array];
    [imageCoordinates addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:35], nil]];
    [imageCoordinates addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:124], [NSNumber numberWithInt:35], nil]];
    [imageCoordinates addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:228], [NSNumber numberWithInt:35], nil]];
    [imageCoordinates addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:116], nil]];
    [imageCoordinates addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:124], [NSNumber numberWithInt:116], nil]];
    [imageCoordinates addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:228], [NSNumber numberWithInt:116], nil]];
    
    for (UserBadge *badge in userBadges) {
        NSURL *url = [NSURL URLWithString:[badge url]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[[UIImage alloc] initWithData:data] autorelease];
        
        NSArray *coords = [imageCoordinates objectAtIndex: [userBadges indexOfObject:badge]];
        
        UIButton *badgeButton = [[[UIButton alloc] initWithFrame:CGRectMake([[coords objectAtIndex:0]intValue], [[coords objectAtIndex:1] intValue], 72, 72)] autorelease];
        [badgeButton setBackgroundImage:image forState:UIControlStateNormal];
        [badgeButton addTarget:self action:@selector(showBadgeText:) forControlEvents:UIControlEventTouchUpInside];
        [badgeButton setTag: [userBadges indexOfObject:badge]];
        [badgesView addSubview:badgeButton];
    }
}

- (void)showBadgeText:(id)sender {
    NSArray *userBadges = [[[ImmopolyManager instance] user] badges];
    NSString *badgeText = [[userBadges objectAtIndex:[sender tag]] text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:badgeText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release]; 
}

- (void)viewDidUnload {
    [super viewDidUnload];  
    
    self.hello = nil;
    self.bank = nil;
    self.miete = nil;
    self.numExposes = nil;
    self.labelBank = nil;
    self.labelMiete = nil;
    self.labelNumExposes = nil;
    self.badgesView = nil;
    self.showBadgesButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)toggleBadgesView {
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
    [numExposes release];
    [labelBank release];
    [labelMiete release];
    [labelNumExposes release];
    [badgesView release];
    [showBadgesButton release];
    [super dealloc];
}

@end
