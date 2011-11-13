//
//  PortfolioViewController.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 29.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PortfolioViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableViewCell *tvCell;
    IBOutlet UITableView *table;
    
    // for switching between list and map 
    UISegmentedControl *segmentedControl;
    MKMapView *portfolioMapView;
}

@property (nonatomic, retain) UITableViewCell *tvCell;
@property (nonatomic, retain) UITableView *table;
@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic,retain) IBOutlet MKMapView *portfolioMapView;

-(IBAction) segmentedControlIndexChanged;

@end
