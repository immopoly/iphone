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

@interface HistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UserDataDelegate,HistoryDelegate> {
    IBOutlet UITableViewCell *tvCell;
    IBOutlet UITableView *table;
    IBOutlet UIActivityIndicatorView *spinner;
    
    LoginCheck *loginCheck;
    BOOL loading;
    BOOL flagForReload;
    int loadingHistoryEntriesStart;
    int loadingHistoryEntriesLimit;
    
}

@property(nonatomic, retain) UITableViewCell *tvCell;
@property(nonatomic, retain) UITableView *table;
@property(nonatomic, retain) LoginCheck *loginCheck;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic, assign) BOOL loading;
@property(nonatomic, assign) BOOL flagForReload;
@property(nonatomic, assign) int loadingHistoryEntriesStart;
@property(nonatomic, assign) int loadingHistoryEntriesLimit;

-(void) stopSpinnerAnimation;

@end
