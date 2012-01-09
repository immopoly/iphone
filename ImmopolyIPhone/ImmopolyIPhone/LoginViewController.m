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
#import "Constants.h"
#import "ResetPasswordTask.h"

@implementation LoginViewController

@synthesize userName;
@synthesize password;
@synthesize spinner;
@synthesize loginLabel;
@synthesize loginButton;
@synthesize delegate;
@synthesize registerView;
@synthesize loginView;
@synthesize registerUserName;
@synthesize registerUserPassword;
@synthesize registerUserEmail;
@synthesize registerUserTwitter;
@synthesize resetPasswordView;
@synthesize resetPasswordUserName;
@synthesize resetPasswordEmail;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"User", @"Third");
        self.tabBarItem.image = [UIImage imageNamed:@"tab_user"];
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
    
    [password setSecureTextEntry:YES];
    [registerUserPassword setSecureTextEntry:YES];
    
    [spinner setHidden:YES];
    [loginLabel setHidden:YES];
    [userName setEnabled:YES];
    [password setEnabled:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.userName = nil;
    self.password = nil;
    self.spinner = nil;
    self.loginLabel = nil;
    self.loginButton = nil;
    self.registerView = nil;
    self.loginView = nil;
    self.registerUserName = nil;
    self.registerUserPassword = nil;
    self.registerUserEmail = nil;
    self.registerUserTwitter = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)performLogin {
    [self setTextFieldsEnabled:NO];
    
    if([[userName text] length]> 0 && [[password text] length] > 0) {
    
        [loginButton setEnabled:NO];
        
        [loginLabel setHidden:NO];
        [spinner setHidden:NO];
        [spinner startAnimating];
        
        UserLoginTask *loader = [[[UserLoginTask alloc] init] autorelease];
        [loader setDelegate:self];
        
        [loader performLogin: [userName text] password: [password text]];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:alertLoginWrongInput delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self setTextFieldsEnabled:YES];
    }
}

- (void)loginWithResult:(BOOL)_result {
    [spinner stopAnimating];
    [spinner setHidden:YES];
    [loginLabel setHidden:YES];
    
    [self setTextFieldsEnabled:YES];
    
    if(_result) {
        //notify delegate
        [delegate notifyMyDelegateView];
        //dismiss modal view
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [userName setEnabled:YES];
        [password setEnabled:YES];
        [loginButton setEnabled:YES];
    }
}

- (IBAction)closeMyself {
    [delegate closeMyDelegateView];
    [self dismissModalViewControllerAnimated:YES];
}

// methods for user registration
- (IBAction)showRegistrationView {
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	CGPoint posRegister = registerView.center;
    CGPoint posLogin = loginView.center;
	posRegister.x = 160.0f;
    posLogin.x = -480.0f;
    registerView.center = posRegister;
    loginView.center = posLogin;
    [UIView commitAnimations];
    
    [userName setText:@""];
    [password setText:@""];
}

- (IBAction)performRegistration {
    [self setTextFieldsEnabled:NO];
    
    if([[registerUserName text] length]> 0 && [[registerUserPassword text] length] > 0) {
        [spinner setHidden:NO];
        [spinner startAnimating];
        
        UserRegisterTask *loader = [[[UserRegisterTask alloc] init] autorelease];
        [loader setDelegate:self];
    
        [loader performRegistration:[registerUserName text] withPassword:[registerUserPassword text] withEmail:[registerUserEmail text] withTwitter:[registerUserTwitter text]];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:alertRegisterWrongInput delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self setTextFieldsEnabled:YES];
    }
}

- (IBAction)closeRegistration {
    // removing text
    [registerUserName setText:@""];
    [registerUserPassword setText:@""];
    [registerUserEmail setText:@""];
    [registerUserTwitter setText:@""];
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
    CGPoint posRegister = registerView.center;
    CGPoint posLogin = loginView.center;
	posRegister.x = 480.0f;
    posLogin.x = 160.0f;
    registerView.center = posRegister;
    loginView.center = posLogin;
    [UIView commitAnimations];
}

- (void)registerWithResult:(BOOL)_result {
    [spinner stopAnimating];
    [spinner setHidden:YES];
    
    [self setTextFieldsEnabled:YES];
    
    if(_result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erfolg" message:alertRegisterSuccessful delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self closeRegistration];
        [self dismissModalViewControllerAnimated:YES];
        UserLoginTask *loader = [[[UserLoginTask alloc] init] autorelease];
        [loader setDelegate:self];
        [loader performLoginWithToken:[[[ImmopolyManager instance] user] userToken]];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Kein Erfolg" message:errorTryAgainLater delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self closeRegistration];
        [self dismissModalViewControllerAnimated:YES];
    }
}

// to let the keyboard go away through the return key
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder]; 
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	CGPoint pos = registerView.center;
	pos.y = 225.0f;
    registerView.center = pos;
    [UIView commitAnimations];
    return YES;
}

// moving the registration view when a textfield is selected
- (void)textFieldDidBeginEditing:(UITextField *)textField {   
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	CGPoint pos = registerView.center;
	pos.y = 136.0f;
    registerView.center = pos;
    [UIView commitAnimations];
}

// dismissing the keyboard when the display is touched somewhere else
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


//show reset password view
- (IBAction)showResetPasswordView {
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	CGPoint posResetPassword = resetPasswordView.center;
    CGPoint posLogin = loginView.center;
	posResetPassword.x = 170.0f;
    posLogin.x = 480.0f;
    resetPasswordView.center = posResetPassword;
    loginView.center = posLogin;
    [UIView commitAnimations];
    [userName setText:@""];
    [password setText:@""];
}

//send reset password request
- (IBAction)performResetPassword {
    if([[resetPasswordUserName text] length]> 0 && [[resetPasswordEmail text] length] > 0) {
        ResetPasswordTask *loader = [[[ResetPasswordTask alloc] init] autorelease];
        [loader setDelegate: self];
        
        [loader performResetPasswordWithUsername:[resetPasswordUserName text] andEmail:[resetPasswordEmail text]];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:alertResetPasswordWrongInput delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)resetPasswordWithResult:(BOOL)result {
    if(result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:alertResetPasswordSuccessful delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self dismissResetPasswordView];
        [self dismissModalViewControllerAnimated:YES];
    }
}


//dismiss reset password view
- (IBAction)dismissResetPasswordView {
    [resetPasswordUserName setText:@""];
    [resetPasswordEmail setText:@""];
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
    CGPoint posResetPassword = resetPasswordView.center;
    CGPoint posLogin = loginView.center;
	posResetPassword.x = -480.0f;
    posLogin.x = 160.0f;
    resetPasswordView.center = posResetPassword;
    loginView.center = posLogin;
    [UIView commitAnimations];
}

- (void)setTextFieldsEnabled:(BOOL)_enabeled {
    [userName setUserInteractionEnabled:_enabeled];
    [password setUserInteractionEnabled:_enabeled];
    
    [registerUserName setUserInteractionEnabled:_enabeled];
    [registerUserPassword setUserInteractionEnabled:_enabeled];
    [registerUserEmail setUserInteractionEnabled:_enabeled];
    [registerUserTwitter setUserInteractionEnabled:_enabeled];
}

@end
