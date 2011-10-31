//
//  LoginViewController.h
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 30.10.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataLoader.h"
#import "UserProfileViewController.h"

@interface LoginViewController : UIViewController {
    
    IBOutlet UITextField *userName;
    IBOutlet UITextField *password;
    UserProfileViewController *userProfileViewController;
}

- (IBAction) performLogin;

@property(nonatomic, retain)IBOutlet UITextField *userName;
@property(nonatomic, retain)IBOutlet UITextField *password;

@end
