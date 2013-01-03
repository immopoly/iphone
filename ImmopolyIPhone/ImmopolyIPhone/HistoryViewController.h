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

@property(nonatomic, strong) UITableViewCell *tvCell;
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) LoginCheck *loginCheck;
@property(nonatomic, assign) BOOL loading;
@property(nonatomic, assign) BOOL flagForReload;
@property(nonatomic, assign) int loadingHistoryEntriesStart;
@property(nonatomic, assign) int loadingHistoryEntriesLimit;

@property(nonatomic, strong) UILabel *lbTime;
@property(nonatomic, strong) UILabel *lbText;
@property(nonatomic, strong) UIButton *btFacebook;
@property(nonatomic, strong) UIButton *btTwitter;
@property(nonatomic, strong) UIButton *btOpenProfile;
@property(nonatomic, strong) UIImageView *lblImage;

@property(nonatomic, strong) UserProfileViewController *userVC;
@property(nonatomic, strong) IBOutlet UIImageView* shadowBottomImageView;

- (void)viewFadeIn:(UIView *)view;
- (void)viewFadeOut:(UIView *)view;
- (IBAction)facebook:(id)sender;
- (IBAction)twitter:(id)sender;
- (IBAction)openUserProfile:(id)sender;

-(IBAction)showCellLabels:(id)sender;

@end
