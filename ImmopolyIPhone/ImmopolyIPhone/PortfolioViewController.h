//
//  PortfolioViewController.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 29.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//



@interface PortfolioViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableViewCell *tvCell;
    IBOutlet UITableView *table;
}

@property (nonatomic, retain) UITableViewCell *tvCell;
@property (nonatomic, retain) UITableView *table;

@end
