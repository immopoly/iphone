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
#import "AsynchronousImageView.h"
#import "UserTask.h"

@implementation UserProfileViewController

@synthesize hello;
@synthesize bank;
@synthesize miete;
@synthesize numExposes;
@synthesize loginCheck;
@synthesize spinner;
@synthesize labelBank;
@synthesize labelMiete;
@synthesize labelNumExposes;
@synthesize badgesView;
@synthesize userImage;
@synthesize loading;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"User", @"Third");
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_user"];
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
    self.loginCheck = [[LoginCheck alloc]init];
    
    [spinner startAnimating];
    
    // setting the text of the helperView
    //[super initHelperView];
    
    // setting the text of the helperView
    [super initHelperViewWithMode:INFO_USER];
}

- (void)viewDidAppear:(BOOL)animated {
    //[self performActionAfterLoginCheck];
    loginCheck.delegate = self;
    [loginCheck checkUserLogin];
    [super viewDidAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    long long uid = [[defaults objectForKey:@"FBUserId"] longLongValue];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%qi/picture?type=large", uid];
    
    //[userImage loadImageFromURLString:urlString forFlat:nil];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [[[UIImage alloc] initWithData:data] autorelease];
    
    // cropping the image
    CGRect cropRect = CGRectMake(image.size.width/4, 0, 100, 100);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    userImage.image = [UIImage imageWithCGImage:imageRef]; 
    CGImageRelease(imageRef);
    
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
    [self stopSpinnerAnimation];
    
    ImmopolyUser *myUser = [[ImmopolyManager instance] user];
    
    if(myUser != nil) {
        [hello setText: [NSString stringWithFormat: @"%@", [myUser userName]]];
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

    for (int i=0; i<[userBadges count]; i++) {
        UserBadge *badge = [userBadges objectAtIndex:i];
        NSURL *url = [NSURL URLWithString:[badge url]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[[UIImage alloc] initWithData:data] autorelease];
        
        //AsynchronousImageView *imgView = [[AsynchronousImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        //[imgView loadImageFromURLString:[badge url] forFlat:nil];
        
        UIButton *btBadge = [UIButton buttonWithType:UIButtonTypeCustom];
        [btBadge setBackgroundImage:image forState:UIControlStateNormal];
        if (i%2 == 0) {
            btBadge.frame = CGRectMake(18+(i*76)-i-1, 2, 60, 60);
        } else {
            btBadge.frame = CGRectMake(18+(i*76)-i-1, 67, 60, 60);
        }
        [btBadge addTarget:self action:@selector(showBadgeText:) forControlEvents:UIControlEventTouchUpInside];
        [btBadge setTag: [userBadges indexOfObject:badge]];
        [badgesView addSubview:btBadge];
    }
}

- (void)showBadgeText:(id)sender {
    NSArray *userBadges = [[[ImmopolyManager instance] user] badges];
    NSString *badgeText = [[userBadges objectAtIndex:[sender tag]] text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:badgeText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release]; 
}

- (void)stopSpinnerAnimation {
    [spinner stopAnimating];
    [spinner setHidden: YES];
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
    self.spinner = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc {
    [hello release];
    [bank release];
    [miete release];
    [numExposes release];
    [loginCheck release];
    [labelBank release];
    [labelMiete release];
    [labelNumExposes release];
    [badgesView release];
    [spinner release];
    [super dealloc];
}

-(void)notifyMyDelegateView{
    loading = NO;
    [spinner stopAnimating];
    [spinner setHidden: YES];
    ImmopolyUser *myUser = [[ImmopolyManager instance] user];
    
    if(myUser != nil) {
        [hello setText: [NSString stringWithFormat: @"%@", [myUser userName]]];
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

- (IBAction)update{
    [spinner setHidden: NO];
    if(!loading){
        UserTask *task = [[[UserTask alloc] init] autorelease];
        task.delegate = self;
        loading = YES;
        
        [task refreshUser:[[ImmopolyManager instance]user].userName];
        [spinner startAnimating];
    }
}

@end
