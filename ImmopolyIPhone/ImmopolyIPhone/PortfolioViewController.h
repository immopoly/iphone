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
#import "Flat.h"
#import "WebViewController.h"

#define METERS_PER_MILE 1609.344

@interface PortfolioViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UserDataDelegate> {
    IBOutlet UITableViewCell *tvCell;
    IBOutlet UITableView *table;
    LoginCheck *loginCheck;
    
    WebViewController *exposeWebViewController;
    
    // for switching between list and map 
    UISegmentedControl *segmentedControl;
    MKMapView *portfolioMapView;
    IBOutlet UIView *calloutBubble;
    
    bool isCalloutBubbleIn;
    bool isOutInCall;
    int selectedExposeId;
    Flat *selectedImmoScoutFlat;
    MKAnnotationView *selViewForHouseImage;
    IBOutlet UILabel *adressLabel;
    IBOutlet UILabel *lbFlatName;
    IBOutlet UILabel *lbFlatDescription;
    IBOutlet UILabel *lbFlatPrice;
    IBOutlet UILabel *lbNumberOfRooms;
    IBOutlet UILabel *lbLivingSpace;
    IBOutlet UIActivityIndicatorView *spinner;
}

@property (nonatomic, retain) UITableViewCell *tvCell;
@property (nonatomic, retain) UITableView *table;
@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic,retain) IBOutlet MKMapView *portfolioMapView;
@property(nonatomic, retain) LoginCheck *loginCheck;
@property(nonatomic, retain) IBOutlet UIView *calloutBubble;
@property(nonatomic, assign) bool isCalloutBubbleIn;
@property(nonatomic, assign) bool isOutInCall;
@property(nonatomic, assign) int selectedExposeId;
@property(nonatomic, retain) Flat *selectedImmoScoutFlat;
@property(nonatomic, retain) MKAnnotationView *selViewForHouseImage;
@property(nonatomic, retain) IBOutlet UILabel *adressLabel;
@property(nonatomic, retain) IBOutlet UILabel *lbFlatName;
@property(nonatomic, retain) IBOutlet UILabel *lbFlatDescription;
@property(nonatomic, retain) IBOutlet UILabel *lbFlatPrice;
@property(nonatomic, retain) IBOutlet UILabel *lbNumberOfRooms;
@property(nonatomic, retain) IBOutlet UILabel *lbLivingSpace;
@property(nonatomic, retain) WebViewController *exposeWebViewController;

@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;

-(IBAction) segmentedControlIndexChanged;
- (IBAction)calloutBubbleOut;
- (void)recenterMap;
- (void)calloutBubbleIn;

@end
