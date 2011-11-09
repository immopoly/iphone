//
//  HistoryViewController.h
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 09.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableViewCell *tvCell;
    IBOutlet UITableView *table;
}

@property (nonatomic, retain) UITableViewCell *tvCell;
@property (nonatomic, retain) UITableView *table;

@end
