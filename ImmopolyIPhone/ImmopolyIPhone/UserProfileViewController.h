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

@interface UserProfileViewController : AbstractViewController <UserDataDelegate, NotifyViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    IBOutlet UILabel *hello;
    IBOutlet UILabel *bank;
    IBOutlet UILabel *miete;
    IBOutlet UILabel *numExposes;
    IBOutlet UILabel *labelBank;
    IBOutlet UILabel *labelMiete;
    IBOutlet UILabel *labelNumExposes;
    IBOutlet UIView *badgesView;
    IBOutlet UIButton *closeProfileButton;
    IBOutlet UITabBar *tabBar;
    IBOutlet UIImageView *topBarImage;
    LoginCheck *loginCheck;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet AsynchronousImageView *userImage;
    BOOL loading;
    UIImagePickerController *picker;
    BOOL userIsNotMyself;
    NSString *otherUserName;
}

@property(nonatomic, retain) IBOutlet UILabel *hello;
@property(nonatomic, retain) IBOutlet UILabel *bank;
@property(nonatomic, retain) IBOutlet UILabel *miete;
@property(nonatomic, retain) IBOutlet UILabel *numExposes;
@property(nonatomic, retain) IBOutlet UILabel *labelBank;
@property(nonatomic, retain) IBOutlet UILabel *labelMiete;
@property(nonatomic, retain) IBOutlet UILabel *labelNumExposes;
@property(nonatomic, retain) IBOutlet UIImageView *topBarImage;

@property(nonatomic, retain) IBOutlet UIView *badgesView;
@property(nonatomic, retain) LoginCheck *loginCheck;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic, retain) IBOutlet AsynchronousImageView *userImage;
@property(nonatomic, retain) IBOutlet UIButton *closeProfileButton;
@property(nonatomic, retain) IBOutlet UITabBar *tabBar;
@property(nonatomic, assign) BOOL loading;
@property(nonatomic, assign) BOOL userIsNotMyself;
@property(nonatomic, retain) NSString *otherUserName;

- (void)displayBadges;
- (void)stopSpinnerAnimation;
- (void)setLabelTextsOfUser:(ImmopolyUser *)_user;
- (void)displayBadges:(ImmopolyUser *)_user;
- (void)loadFacebookPicture;
- (IBAction)changeProfilePic;
- (IBAction)closeProfile;
- (void)prepareOtherUserProfile;

@end
