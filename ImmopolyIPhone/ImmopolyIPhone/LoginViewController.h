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
#import "ResetPasswordDelegate.h"

@interface LoginViewController : UIViewController <LoginDelegate, RegisterDelegate, ResetPasswordDelegate>{
    
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
    IBOutlet UIView *resetPasswordView;
    IBOutlet UITextField *resetPasswordUserName;
    IBOutlet UITextField *resetPasswordEmail;
    
    UserProfileViewController *userProfileViewController;
    id<NotifyViewDelegate> __unsafe_unretained delegate;
    
}

@property(nonatomic, strong) IBOutlet UITextField *userName;
@property(nonatomic, strong) IBOutlet UITextField *password;
@property(nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic, strong) IBOutlet IBOutlet UILabel *loginLabel;
@property(nonatomic, strong) IBOutlet UIButton *loginButton;
@property(nonatomic, unsafe_unretained) id<NotifyViewDelegate> delegate;

@property(nonatomic, strong) IBOutlet UIView *registerView;
@property(nonatomic, strong) IBOutlet UIView *loginView;
@property(nonatomic, strong) IBOutlet UITextField *registerUserName;
@property(nonatomic, strong) IBOutlet UITextField *registerUserPassword;
@property(nonatomic, strong) IBOutlet UITextField *registerUserEmail;
@property(nonatomic, strong) IBOutlet UITextField *registerUserTwitter;

@property(nonatomic, strong) IBOutlet UIView *resetPasswordView;
@property(nonatomic, strong) IBOutlet UITextField *resetPasswordUserName;
@property(nonatomic, strong) IBOutlet UITextField *resetPasswordEmail;


- (IBAction)performLogin;
- (IBAction)closeMyself;
- (IBAction)performLogin;
- (IBAction)showRegistrationView;
- (IBAction)performRegistration;
- (IBAction)closeRegistration;
- (IBAction)dismissKeyboard;
- (IBAction)showResetPasswordView;
- (IBAction)performResetPassword;
- (IBAction)dismissResetPasswordView;
- (void)setTextFieldsEnabled:(BOOL)_enabeled;
-(BOOL) NSStringIsValidEmail:(NSString *)checkString;

@end
