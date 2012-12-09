//
//  PortfolioViewController.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 29.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "UserDataDelegate.h"
//#import "LoginCheck.h"
#import "Flat.h"
#import "WebViewController.h"
#import "AsynchronousImageView.h"
#import "AbstractViewController.h"
#import "PortfolioDelegate.h"

#define METERS_PER_MILE 5000.00
#define ANNO_WIDTH 40
#define ANNO_HEIGHT 51

@interface PortfolioViewController : AbstractViewController <UITableViewDataSource, UITableViewDelegate, UserDataDelegate, MKMapViewDelegate, UIPageViewControllerDelegate,NotifyViewDelegate,PortfolioDelegate> {
    IBOutlet UITableViewCell *tvCell;
    IBOutlet UITableView *table;
    IBOutlet UILabel *adressLabel;
    IBOutlet UILabel *lbFlatName;
    IBOutlet UILabel *lbFlatDescription;
    IBOutlet UILabel *lbFlatPrice;
    IBOutlet UILabel *lbNumberOfRooms;
    IBOutlet UILabel *lbLivingSpace;
    IBOutlet AsynchronousImageView *asyncImageView;
    IBOutlet UIImageView *topBar;
    IBOutlet UIButton *btRecenterMap;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UILabel *lbPageNumber;

    IBOutlet UIImageView *imgShadowTop;
    IBOutlet UIImageView *imgShadowBottom;

    BOOL loading;
    
    LoginCheck *loginCheck;
    
    WebViewController *exposeWebViewController;
    
    // for switching between list and map 
    UISegmentedControl *segmentedControl;
    MKMapView *portfolioMapView;
    IBOutlet UIView *calloutBubble;
    
    bool isBtHidden;
    bool isCalloutBubbleIn;
    bool isOutInCall;
    bool showCalloutBubble;
    int selectedExposeId;
    Flat *selectedImmoScoutFlat;
    
    // variables vor clustering
    float iphoneScaleFactorLatitude;
    float iphoneScaleFactorLongitude;
    CLLocationDegrees zoomLevel;
    int numOfScrollViewSubviews;
    Flat *sameFlat;
    MKCoordinateSpan regionSpan;
    
    BOOL portfolioHasChanged;
}

@property(nonatomic, strong) UITableViewCell *tvCell;
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, strong) IBOutlet MKMapView *portfolioMapView;
@property(nonatomic, strong) LoginCheck *loginCheck;
@property(nonatomic, strong) IBOutlet UIView *calloutBubble;
@property(nonatomic, assign) bool isCalloutBubbleIn;
@property(nonatomic, assign) bool isOutInCall;
@property(nonatomic, assign) bool showCalloutBubble;
@property(nonatomic, assign) int selectedExposeId;
@property(nonatomic, strong) Flat *selectedImmoScoutFlat;
@property(nonatomic, strong) IBOutlet UILabel *adressLabel;
@property(nonatomic, strong) IBOutlet UILabel *lbFlatName;
@property(nonatomic, strong) IBOutlet UILabel *lbFlatDescription;
@property(nonatomic, strong) IBOutlet UILabel *lbFlatPrice;
@property(nonatomic, strong) IBOutlet UILabel *lbNumberOfRooms;
@property(nonatomic, strong) IBOutlet UILabel *lbLivingSpace;
@property(nonatomic, strong) IBOutlet AsynchronousImageView *asyncImageView;
@property(nonatomic, strong) WebViewController *exposeWebViewController;
@property(nonatomic, strong) IBOutlet UIButton *btRecenterMap;
@property(nonatomic, assign) bool isBtHidden;
@property(nonatomic, strong) IBOutlet UIImageView *topBar;
@property(nonatomic, assign) float iphoneScaleFactorLatitude;
@property(nonatomic, assign) float iphoneScaleFactorLongitude;
@property(nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic, assign) int numOfScrollViewSubviews;
@property(nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property(nonatomic, strong) IBOutlet UIImageView *calloutBubbleImg;
@property(nonatomic, strong) IBOutlet UILabel *lbPageNumber;
@property(nonatomic, strong) IBOutlet UIImageView *imgShadowTop;
@property(nonatomic, strong) IBOutlet UIImageView *imgShadowBottom;
@property(nonatomic, strong) Flat *sameFlat;
@property(nonatomic, assign) MKCoordinateSpan regionSpan;
@property(nonatomic, assign) BOOL loading;
@property(nonatomic, assign) BOOL portfolioHasChanged;

- (void)calloutBubbleOut;
- (void)recenterMap;
- (void)calloutBubbleIn;
- (IBAction)showAllFlats;
- (IBAction)showList;
- (void)showListWithAnimation:(BOOL)_animated;
- (IBAction)showMap;
- (void)showMapWithAnimation:(BOOL)_animated;
- (IBAction)closeBubble;

- (void)setAnnotationImageAtAnnotation:(Flat *)_flat;
- (UILabel *)setLbNumberOfFlatsAtFlat:(Flat *)_flat;
- (void)filterAnnotations:(NSArray *)_flatsToFilter;
- (void)initScrollView;
- (UIView *)createCalloutBubbleContentFromFlat:(Flat *)_flat atPosition:(int)_pos;
- (void)handleBubbleTap;

@end
