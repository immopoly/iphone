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

@property(nonatomic, strong) IBOutlet UILabel *hello;
@property(nonatomic, strong) IBOutlet UILabel *bank;
@property(nonatomic, strong) IBOutlet UILabel *miete;
@property(nonatomic, strong) IBOutlet UILabel *numExposes;
@property(nonatomic, strong) IBOutlet UILabel *labelBank;
@property(nonatomic, strong) IBOutlet UILabel *labelMiete;
@property(nonatomic, strong) IBOutlet UILabel *labelNumExposes;
@property(nonatomic, strong) IBOutlet UIImageView *topBarImage;
@property(nonatomic, strong) UIScrollView *badgesScrollView;
@property(nonatomic, strong) UIScrollView *actionsScrollView;
@property(nonatomic, strong) LoginCheck *loginCheck;
@property(nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic, strong) IBOutlet AsynchronousImageView *userImage;
@property(nonatomic, strong) IBOutlet UIButton *closeProfileButton;
@property(nonatomic, strong) IBOutlet UIButton *btShowBadges;
@property(nonatomic, strong) IBOutlet UIButton *btShowItems;
@property(nonatomic, strong) IBOutlet UILabel *closeProfileButtonLabel;
@property(nonatomic, strong) IBOutlet UITabBar *tabBar;
@property(nonatomic, assign) BOOL loading;
@property(nonatomic, assign) BOOL userIsNotMyself;
@property(nonatomic, assign) int numberOfBadges;
@property(nonatomic, assign) int numberOfActions;
@property(nonatomic, strong) NSString *otherUserName;
@property(nonatomic, strong) ImmopolyUser *otherUser;
@property(nonatomic, strong) UIView *itemsView;
@property(nonatomic, strong) IBOutlet UIImageView* badgesImageView;

- (void)setLabelTextsOfUser:(ImmopolyUser *)_user;
//- (void)displayBadges:(ImmopolyUser *)_user;
- (void)displayItems:(NSMutableArray *)_items ofScrollView:(UIScrollView *)_scrollView;
- (void)loadFacebookPicture;
- (IBAction)changeProfilePic;
- (IBAction)closeProfile;
- (void)prepareOtherUserProfile;
- (IBAction)toggleBadgesAndItemsView:(id)_sender;

@end
