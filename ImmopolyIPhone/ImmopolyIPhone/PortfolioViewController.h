//
//  PortfolioViewController.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 29.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "UserDataDelegate.h"
#import "LoginCheck.h"

@interface PortfolioViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UserDataDelegate> {
    IBOutlet UITableViewCell *tvCell;
    IBOutlet UITableView *table;
    LoginCheck *loginCheck;
    
    // for switching between list and map 
    UISegmentedControl *segmentedControl;
    MKMapView *portfolioMapView;
}

@property (nonatomic, retain) UITableViewCell *tvCell;
@property (nonatomic, retain) UITableView *table;
@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic,retain) IBOutlet MKMapView *portfolioMapView;
@property(nonatomic, retain) LoginCheck *loginCheck;

-(IBAction) segmentedControlIndexChanged;

@end
