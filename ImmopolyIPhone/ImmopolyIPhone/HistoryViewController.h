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

@interface HistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UserDataDelegate> {
    IBOutlet UITableViewCell *tvCell;
    IBOutlet UITableView *table;
    LoginCheck *loginCheck;
    IBOutlet UIActivityIndicatorView *spinner;
}

@property (nonatomic, retain) UITableViewCell *tvCell;
@property (nonatomic, retain) UITableView *table;
@property(nonatomic, retain) LoginCheck *loginCheck;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;

@end
