//
//  HistoryViewController.h
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 09.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDataDelegate.h"
//#import "LoginCheck.h"
#import "HistoryDelegate.h"
#import "AbstractViewController.h"
#import "FacebookManagerDelegate.h"
#import <Twitter/Twitter.h>
#import "HistoryEntry.h"

@interface HistoryViewController : AbstractViewController <UITableViewDataSource, UITableViewDelegate, UserDataDelegate, HistoryDelegate, FacebookManagerDelegate> {
    IBOutlet UITableViewCell *tvCell;
    IBOutlet UITableView *table;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UIActivityIndicatorView *reloadDataSpinner;
    IBOutlet UILabel *lbTime;
    IBOutlet UILabel *lbText;
    IBOutlet UIButton *btShareBack;
    IBOutlet UIButton *btFacebook;
    IBOutlet UIButton *btTwitter;
    
    //LoginCheck *loginCheck;
    BOOL loading;
    BOOL flagForReload;
    int loadingHistoryEntriesStart;
    int loadingHistoryEntriesLimit;
    
    HistoryEntry *selectedHistoryEntry;
    
}

@property(nonatomic, retain) UITableViewCell *tvCell;
@property(nonatomic, retain) UITableView *table;
//@property(nonatomic, retain) LoginCheck *loginCheck;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic, assign) BOOL loading;
@property(nonatomic, assign) BOOL flagForReload;
@property(nonatomic, assign) int loadingHistoryEntriesStart;
@property(nonatomic, assign) int loadingHistoryEntriesLimit;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *reloadDataSpinner;
@property(nonatomic, retain) HistoryEntry *selectedHistoryEntry;
@property(nonatomic, retain) IBOutlet UILabel *lbTime;
@property(nonatomic, retain) IBOutlet UILabel *lbText;
@property(nonatomic, retain) IBOutlet UIButton *btShareBack;
@property(nonatomic, retain) IBOutlet UIButton *btFacebook;
@property(nonatomic, retain) IBOutlet UIButton *btTwitter;

- (void)stopSpinnerAnimation;
- (IBAction)showCellLabels;
- (void)viewFadeIn:(UIView *)view;
- (void)viewFadeOut:(UIView *)view;
- (IBAction)facebook;
- (IBAction)twitter;
- (void)showTweet;

@end
