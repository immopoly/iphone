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
#import "AbstractViewController.h"
#import "AsynchronousImageView.h"
#import "ImmopolyUser.h"

@interface UserProfileViewController : AbstractViewController <UserDataDelegate,NotifyViewDelegate> {
    
    IBOutlet UILabel *hello;
    IBOutlet UILabel *bank;
    IBOutlet UILabel *miete;
    IBOutlet UILabel *numExposes;
    IBOutlet UILabel *labelBank;
    IBOutlet UILabel *labelMiete;
    IBOutlet UILabel *labelNumExposes;
    IBOutlet UIView *badgesView;
    LoginCheck *loginCheck;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet AsynchronousImageView *userImage;
    BOOL loading;
}

@property(nonatomic, retain) IBOutlet UILabel *hello;
@property(nonatomic, retain) IBOutlet UILabel *bank;
@property(nonatomic, retain) IBOutlet UILabel *miete;
@property(nonatomic, retain) IBOutlet UILabel *numExposes;
@property(nonatomic, retain) IBOutlet UILabel *labelBank;
@property(nonatomic, retain) IBOutlet UILabel *labelMiete;
@property(nonatomic, retain) IBOutlet UILabel *labelNumExposes;

@property(nonatomic, retain) IBOutlet UIView *badgesView;
@property(nonatomic, retain) LoginCheck *loginCheck;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic, retain) IBOutlet AsynchronousImageView *userImage;
@property(nonatomic, assign) BOOL loading;

- (void)displayBadges;
- (void)stopSpinnerAnimation;
- (void)setLabelTextsOfUser:(ImmopolyUser *)_user;
- (void)loadFacebookPicture;

@end
