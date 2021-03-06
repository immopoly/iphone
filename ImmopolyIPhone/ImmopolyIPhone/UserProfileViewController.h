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

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface UserProfileViewController : AbstractViewController <UserDataDelegate, NotifyViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    IBOutlet UILabel *hello;
    IBOutlet UILabel *bank;
    IBOutlet UILabel *miete;
    IBOutlet UILabel *numExposes;
    IBOutlet UILabel *labelBank;
    IBOutlet UILabel *labelMiete;
    IBOutlet UILabel *labelNumExposes;
    UIScrollView *badgesScrollView;
    IBOutlet UIButton *closeProfileButton;
    IBOutlet UIButton *btShowBadges;
    IBOutlet UIButton *btShowItems;
    IBOutlet UILabel *closeProfileButtonLabel;
    IBOutlet UITabBar *tabBar;
    IBOutlet UIImageView *topBarImage;
    IBOutlet UIImageView *badgesViewBackground;
    IBOutlet AsynchronousImageView *userImage;
    IBOutlet UIView *itemsView;
    UIScrollView *actionsScrollView;
    LoginCheck *loginCheck;
    BOOL loading;
    UIImagePickerController *picker;
    BOOL userIsNotMyself;
    int numberOfBadges;
    int numberOfActions;
    NSString *otherUserName;
    ImmopolyUser *otherUser;
}

@property(nonatomic, retain) IBOutlet UILabel *hello;
@property(nonatomic, retain) IBOutlet UILabel *bank;
@property(nonatomic, retain) IBOutlet UILabel *miete;
@property(nonatomic, retain) IBOutlet UILabel *numExposes;
@property(nonatomic, retain) IBOutlet UILabel *labelBank;
@property(nonatomic, retain) IBOutlet UILabel *labelMiete;
@property(nonatomic, retain) IBOutlet UILabel *labelNumExposes;
@property(nonatomic, retain) IBOutlet UIImageView *topBarImage;
@property(nonatomic, retain) UIScrollView *badgesScrollView;
@property(nonatomic, retain) UIScrollView *actionsScrollView;
@property(nonatomic, retain) LoginCheck *loginCheck;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic, retain) IBOutlet AsynchronousImageView *userImage;
@property(nonatomic, retain) IBOutlet UIButton *closeProfileButton;
@property(nonatomic, retain) IBOutlet UIButton *btShowBadges;
@property(nonatomic, retain) IBOutlet UIButton *btShowItems;
@property(nonatomic, retain) IBOutlet UILabel *closeProfileButtonLabel;
@property(nonatomic, retain) IBOutlet UITabBar *tabBar;
@property(nonatomic, assign) BOOL loading;
@property(nonatomic, assign) BOOL userIsNotMyself;
@property(nonatomic, assign) int numberOfBadges;
@property(nonatomic, assign) int numberOfActions;
@property(nonatomic, retain) NSString *otherUserName;
@property(nonatomic, retain) ImmopolyUser *otherUser;
@property(nonatomic, retain) UIView *itemsView;

- (void)setLabelTextsOfUser:(ImmopolyUser *)_user;
//- (void)displayBadges:(ImmopolyUser *)_user;
- (void)displayItems:(NSMutableArray *)_items ofScrollView:(UIScrollView *)_scrollView;
- (void)loadFacebookPicture;
- (IBAction)changeProfilePic;
- (IBAction)closeProfile;
- (void)prepareOtherUserProfile;
- (IBAction)toggleBadgesAndItemsView:(id)_sender;

@end
