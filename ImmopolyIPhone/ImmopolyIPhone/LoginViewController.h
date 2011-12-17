//
//  LoginViewController.h
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 30.10.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserLoginTask.h"
#import "UserRegisterTask.h"
#import "UserProfileViewController.h"
#import "PortfolioViewController.h"
#import "UserDataDelegate.h"
#import "NotifyViewDelegate.h"

@interface LoginViewController : UIViewController <LoginDelegate, RegisterDelegate>{
    
    IBOutlet UITextField *userName;
    IBOutlet UITextField *password;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UILabel *loginLabel;
    IBOutlet UIButton *loginButton;
    IBOutlet UIView *registerView;
    IBOutlet UIView *loginView;
    IBOutlet UITextField *registerUserName;
    IBOutlet UITextField *registerUserPassword;
    IBOutlet UITextField *registerUserEmail;
    IBOutlet UITextField *registerUserTwitter;
    
    
    UserProfileViewController *userProfileViewController;
    id<NotifyViewDelegate> delegate;
    
}

@property(nonatomic, retain) IBOutlet UITextField *userName;
@property(nonatomic, retain) IBOutlet UITextField *password;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic, retain) IBOutlet IBOutlet UILabel *loginLabel;
@property(nonatomic, retain) IBOutlet UIButton *loginButton;
@property(nonatomic, assign) id<NotifyViewDelegate> delegate;

@property(nonatomic, retain) IBOutlet UIView *registerView;
@property(nonatomic, retain) IBOutlet UIView *loginView;
@property(nonatomic, retain) IBOutlet UITextField *registerUserName;
@property(nonatomic, retain) IBOutlet UITextField *registerUserPassword;
@property(nonatomic, retain) IBOutlet UITextField *registerUserEmail;
@property(nonatomic, retain) IBOutlet UITextField *registerUserTwitter;

- (IBAction) performLogin;
- (IBAction) closeMyself;
- (IBAction) performLogin;
- (IBAction) showRegistrationView;
- (IBAction) performRegistration;
- (IBAction) closeRegistration;
- (IBAction) dismissKeyboard;

@end
