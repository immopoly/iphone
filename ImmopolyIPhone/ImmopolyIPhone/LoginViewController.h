//
//  LoginViewController.h
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 30.10.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserLoginTask.h"
#import "UserProfileViewController.h"

@interface LoginViewController : UIViewController <LoginDelegate>{
    
    IBOutlet UITextField *userName;
    IBOutlet UITextField *password;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UILabel *loginLabel;
    UserProfileViewController *userProfileViewController;
}

- (IBAction) performLogin;

@property(nonatomic, retain)IBOutlet UITextField *userName;
@property(nonatomic, retain)IBOutlet UITextField *password;
@property(nonatomic, retain)IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic, retain)IBOutlet IBOutlet UILabel *loginLabel;
@end
