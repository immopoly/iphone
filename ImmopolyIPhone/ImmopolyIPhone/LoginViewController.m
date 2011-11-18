//
//  LoginViewController.m
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 30.10.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import "LoginViewController.h"
#import "UserLoginTask.h"
#import "ImmopolyManager.h"

@implementation LoginViewController

@synthesize userName, password,spinner,loginLabel, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"User", @"Third");
        self.tabBarItem.image = [UIImage imageNamed:@"tab_user"];
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
    /*
    [super viewDidLoad];
    
    [password setSecureTextEntry:YES];
    
    [spinner startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"userToken"] != nil) {
        //get user token
        NSString *userToken = [defaults objectForKey:@"userToken"];
        //login with token
        UserLoginTask *loader = [[UserLoginTask alloc] init];
        loader.delegate = self;
        
        [loader performLoginWithToken: userToken];
        
        [loader autorelease];
    }    
    else {
        [spinner stopAnimating];
        [spinner setHidden:YES];
        [loginLabel setHidden:YES];
        [userName setEnabled:YES];
        [password setEnabled:YES];
    }
     */
    [super viewDidLoad];
    
    [password setSecureTextEntry:YES];
    
    [spinner setHidden:YES];
    [loginLabel setHidden:YES];
    [userName setEnabled:YES];
    [password setEnabled:YES];
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
    
        [loginLabel setHidden:NO];
        [spinner setHidden:NO];
        [spinner startAnimating];
        
        UserLoginTask *loader = [[UserLoginTask alloc] init];
        [loader setDelegate:self];
        
        [loader performLogin: [userName text] password: [password text]];
        
        //wrong place to check
        //to login process is done in an asynchrounous thread next to the main thread
        //in ur case this check is done immediately after the method call
        //therefore we implemented the LoginDelegate
        
        /*
        if([ImmopolyManager instance].loginSuccessful == YES) {
            //show user profile view
            userProfileViewController = [[UserProfileViewController alloc] init];
            [self.view addSubview: userProfileViewController.view];
        }*/
        
        [loader release];
        [userName resignFirstResponder];
        [password resignFirstResponder];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong input" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void) loginWithResult: (BOOL) result{
    [spinner stopAnimating];
    [spinner setHidden:YES];
    [loginLabel setHidden:YES];
    if(result) {
        //notify delegate
        [delegate notifyMyDelegateView];
        //dismiss modal view
        [self dismissModalViewControllerAnimated:YES];
    }else{
        [userName setEnabled:YES];
        [password setEnabled:YES];
    }
}

-(IBAction) dismissView {
    [delegate closeMyDelegateView];
    [self dismissModalViewControllerAnimated:YES];
}

@end
