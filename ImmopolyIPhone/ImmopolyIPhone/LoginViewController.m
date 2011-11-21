//
//  LoginViewController.m
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 30.10.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import "LoginViewController.h"
#import "UserLoginTask.h"
#import "UserRegisterTask.h"
#import "ImmopolyManager.h"

@implementation LoginViewController

@synthesize userName, password,spinner,loginLabel, delegate;
@synthesize registerView, registerUserName, registerUserPassword, registerUserEmail, registerUserTwitter;

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
    [registerUserPassword setSecureTextEntry:YES];
    
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
        
        UserLoginTask *loader = [[[UserLoginTask alloc] init] autorelease];
        [loader setDelegate:self];
        
        [loader performLogin: [userName text] password: [password text]];
        
//        [userName resignFirstResponder];
//        [password resignFirstResponder];
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
-(IBAction)showRegistrationView {
//   [[self view]addSubview:registerView];
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	CGPoint pos = registerView.center;
	pos.x = 160.0f;
    registerView.center = pos;
    [UIView commitAnimations];
}

-(IBAction)performRegistration {
    
    if([[registerUserName text] length]> 0 && [[registerUserPassword text] length] > 0) {
        UserRegisterTask *loader = [[[UserRegisterTask alloc] init] autorelease];
        [loader setDelegate:self];
    
        [loader performRegistration:[registerUserName text] withPassword:[registerUserPassword text] withEmail:[registerUserEmail text] withTwitter:[registerUserTwitter text]];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Es wurde eine falsche Eingabe getätigt." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(IBAction) closeRegistration {
    // removing text
    [registerUserName setText:@""];
    [registerUserPassword setText:@""];
    [registerUserEmail setText:@""];
    [registerUserTwitter setText:@""];
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	CGPoint pos = registerView.center;
	pos.x = 480.0f;
    registerView.center = pos;
    [UIView commitAnimations];
    
//    [registerView removeFromSuperview];
}

-(void) registerWithResult:(BOOL)result {
    
    if(result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Glückwunsch! Du hast dich erfolgreich registriert und kannst dich nun einlogen." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self closeRegistration];
        [self dismissModalViewControllerAnimated:YES];
        UserLoginTask *loader = [[[UserLoginTask alloc] init] autorelease];
        [loader setDelegate:self];
        [loader performLoginWithToken:[[[ImmopolyManager instance] user] userToken]];
    }else{
        [self closeRegistration];
        [self dismissModalViewControllerAnimated:YES];
    }
}

// to let the keyboard go away through the return key
-(BOOL) textFieldShouldReturn:(UITextField *) textField {
    [textField resignFirstResponder]; 
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	CGPoint pos = registerView.center;
	pos.y = 225.0f;
    registerView.center = pos;
    [UIView commitAnimations];
    return YES;
}

// moving the keyboard when a textfield is selected
- (void)textFieldDidBeginEditing:(UITextField *)textField {   
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	CGPoint pos = registerView.center;
	pos.y = 117.0f;
    registerView.center = pos;
    [UIView commitAnimations];
}

// moving the keyboard when a the display is touched somewhere else
- (IBAction) dismissKeyboard {
    NSLog(@"dismiss keyboard");
    [userName resignFirstResponder];
    [password resignFirstResponder];
    [registerUserName resignFirstResponder];
    [registerUserPassword resignFirstResponder];
    [registerUserEmail resignFirstResponder];
    [registerUserTwitter resignFirstResponder];
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	CGPoint pos = registerView.center;
	pos.y = 225.0f;
    registerView.center = pos;
    [UIView commitAnimations];
}

@end
