//
//  HistoryViewController.h
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 09.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDataDelegate.h"
#import "LoginCheck.h"
#import "HistoryDelegate.h"
#import "AbstractViewController.h"
#import "FacebookManagerDelegate.h"
#import <Twitter/Twitter.h>
#import "HistoryEntry.h"
#import "UserProfileViewController.h"

@interface HistoryViewController : AbstractViewController <UITableViewDataSource, UITableViewDelegate, UserDataDelegate, HistoryDelegate, FacebookManagerDelegate> {
    IBOutlet UITableViewCell *tvCell;
    IBOutlet UITableView *table;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UIActivityIndicatorView *reloadDataSpinner;
    UILabel *lbTime;
    UILabel *lbText;
    UIButton *btFacebook;
    UIButton *btTwitter;
    UIButton *btOpenProfile;
    UIImageView *lblImage;
    
    LoginCheck *loginCheck;
    BOOL loading;
    BOOL flagForReload;
    int loadingHistoryEntriesStart;
    int loadingHistoryEntriesLimit;
    
    UserProfileViewController *userVC;
    
    
}

@property(nonatomic, retain) UITableViewCell *tvCell;
@property(nonatomic, retain) UITableView *table;
@property(nonatomic, retain) LoginCheck *loginCheck;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic, assign) BOOL loading;
@property(nonatomic, assign) BOOL flagForReload;
@property(nonatomic, assign) int loadingHistoryEntriesStart;
@property(nonatomic, assign) int loadingHistoryEntriesLimit;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *reloadDataSpinner;

@property(nonatomic, retain) UILabel *lbTime;
@property(nonatomic, retain) UILabel *lbText;
@property(nonatomic, retain) UIButton *btFacebook;
@property(nonatomic, retain) UIButton *btTwitter;
@property(nonatomic, retain) UIButton *btOpenProfile;
@property(nonatomic, retain) UIImageView *lblImage;

@property(nonatomic, retain) UserProfileViewController *userVC;

- (void)stopSpinnerAnimation;
//- (IBAction)showCellLabels;
- (void)viewFadeIn:(UIView *)view;
- (void)viewFadeOut:(UIView *)view;
- (IBAction)facebook:(id)sender;
- (IBAction)twitter:(id)sender;
- (IBAction)openUserProfile:(id)sender;
- (IBAction)update;

-(IBAction)showCellLabels:(id)sender;

@end
