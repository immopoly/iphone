//
//  ImmopolyMapViewController.m
//  libOAuthDemo
//
//  Created by Maria Guseva on 26.10.11.
//  Copyright (c) 2011 Immobilienscout24. All rights reserved.
//

#import "ImmopolyMapViewController.h"
#import "ImmopolyManager.h"
#import "Flat.h"
#import "AppDelegate.h"
#import "UserLoginTask.h"
#import "AsynchronousImageView.h"
#import "Constants.h"

static NSString *ANNO_IMG_SINGLE = @"Haus_neu_hdpi.png";
static NSString *ANNO_IMG_MULTI = @"Haus_cluster_hpdi.png";
static NSString *ANNO_IMG_OWN = @"Haus_meins_hdpi.png";

@interface ImmopolyMapViewController ()

@end

@implementation ImmopolyMapViewController 

@synthesize adressLabel;
@synthesize actualiseButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
        self.title = NSLocalizedString(@"Map", @"First");
        self.tabBarItem.image = nil;
        mapView.delegate = self;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {  
    if (![self alreadyUsed]) {
       //Show first start text
        
        [self initHelperViewWithMode:INFO_IMMOPOLY];
        [self initButton];
        [self helperViewIn];
        
       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alreadyUsed"];
    }else{
        [self initHelperViewWithMode:INFO_MAP];
    }
}

- (void)helperViewIn {
    if ([self alreadyUsed]) {
        [self initHelperViewWithMode:INFO_MAP];
    }
    [super helperViewIn];
}

- (BOOL)alreadyUsed{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"alreadyUsed"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [ImmopolyManager instance].delegate = self;
}

- (void)viewDidUnload {
    [super viewDidUnload];    
    self.adressLabel = nil;
    self.actualiseButton = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:actualiseButton];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - LocationDelegate

- (void)setAdressLabelText:(NSString *)_locationName {
    [adressLabel setText:_locationName];
}

- (void)displayCurrentLocation {
    [super recenterMap];
}

- (IBAction)refreshLocation {
    [super calloutBubbleOut];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate startLocationUpdate];
    
    [delegate setIsLocationUpdated:NO];
    [[[ImmopolyManager instance] immoScoutFlats] removeAllObjects];
}

- (void)showFlatSpinner{
    [[super spinner]setHidden:NO];
    [[super spinner]startAnimating];
}

@end