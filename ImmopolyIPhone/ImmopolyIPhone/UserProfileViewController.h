//
//  UserProfileViewController.h
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 30.10.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDataDelegate.h"
#import "LoginDelegate.h"
#import "LoginCheck.h"

@interface UserProfileViewController : UIViewController <UserDataDelegate> {
    
    IBOutlet UILabel *hello;
    IBOutlet UILabel *bank;
    IBOutlet UILabel *miete;
    IBOutlet UILabel *provision;
    LoginCheck *loginCheck;
}

@property(nonatomic, retain) IBOutlet UILabel *hello;
@property(nonatomic, retain) IBOutlet UILabel *bank;
@property(nonatomic, retain) IBOutlet UILabel *miete;
@property(nonatomic, retain) IBOutlet UILabel *provision;
@property(nonatomic, retain) LoginCheck *loginCheck;

-(void) displayUserData;

@end
