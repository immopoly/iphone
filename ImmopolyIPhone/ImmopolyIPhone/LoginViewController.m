//
//  LoginViewController.m
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 30.10.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import "LoginViewController.h"
#import "DataLoader.h"
#import "ImmopolyManager.h"

@implementation LoginViewController

@synthesize userName, password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [password setSecureTextEntry:YES];
    // Do any additional setup after loading the view from its nib.
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

-(IBAction)performLogin {
    if([[userName text] length]> 0 && [[password text] length] > 0) {
        
        DataLoader *loader = [[DataLoader alloc] init];
        [loader performLogin: [userName text] password: [password text]];
        
        if([ImmopolyManager instance].loginSuccessful == YES) {
            //show user profile view
            userProfileViewController = [[UserProfileViewController alloc] init];
            [self.view addSubview: userProfileViewController.view];
        }
        
        [loader release];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong input" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

@end
