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

#define METERS_PER_MILE 1609.344
#define ANNO_WIDTH 40
#define ANNO_HEIGHT 51

@interface PortfolioViewController : AbstractViewController <UITableViewDataSource, UITableViewDelegate, UserDataDelegate, MKMapViewDelegate, UIPageViewControllerDelegate> {
    IBOutlet UITableViewCell *tvCell;
    IBOutlet UITableView *table;
    IBOutlet UILabel *adressLabel;
    IBOutlet UILabel *lbFlatName;
    IBOutlet UILabel *lbFlatDescription;
    IBOutlet UILabel *lbFlatPrice;
    IBOutlet UILabel *lbNumberOfRooms;
    IBOutlet UILabel *lbLivingSpace;
    IBOutlet AsynchronousImageView *asyncImageView;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UIImageView *topBar;
    IBOutlet UIButton *btRecenterMap;    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIImageView *calloutBubbleImg;
//    IBOutlet UIButton *btShowFlatsWebView;
    IBOutlet UILabel *lbPageNumber;

    IBOutlet UIImageView *imgShadowTop;
    IBOutlet UIImageView *imgShadowBottom;

    
    //LoginCheck *loginCheck;
    
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
    MKAnnotationView *selViewForHouseImage;
    MKAnnotationView *selViewForHouseImageInOut;
    
    // variables vor clustering
    float iphoneScaleFactorLatitude;
    float iphoneScaleFactorLongitude;
    CLLocationDegrees zoomLevel;
    int numOfScrollViewSubviews;
    Flat *sameFlat;
    MKCoordinateSpan regionSpan;
}

@property(nonatomic, retain) UITableViewCell *tvCell;
@property(nonatomic, retain) UITableView *table;
@property(nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, retain) IBOutlet MKMapView *portfolioMapView;
//@property(nonatomic, retain) LoginCheck *loginCheck;
@property(nonatomic, retain) IBOutlet UIView *calloutBubble;
@property(nonatomic, assign) bool isCalloutBubbleIn;
@property(nonatomic, assign) bool isOutInCall;
@property(nonatomic, assign) bool showCalloutBubble;
@property(nonatomic, assign) int selectedExposeId;
@property(nonatomic, retain) Flat *selectedImmoScoutFlat;
@property(nonatomic, retain) IBOutlet UILabel *adressLabel;
@property(nonatomic, retain) IBOutlet UILabel *lbFlatName;
@property(nonatomic, retain) IBOutlet UILabel *lbFlatDescription;
@property(nonatomic, retain) IBOutlet UILabel *lbFlatPrice;
@property(nonatomic, retain) IBOutlet UILabel *lbNumberOfRooms;
@property(nonatomic, retain) IBOutlet UILabel *lbLivingSpace;
@property(nonatomic, retain) IBOutlet AsynchronousImageView *asyncImageView;
@property(nonatomic, retain) WebViewController *exposeWebViewController;
@property(nonatomic, retain) IBOutlet UIButton *btRecenterMap;
@property(nonatomic, assign) bool isBtHidden;
@property(nonatomic, retain) IBOutlet UIImageView *topBar;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic, assign) float iphoneScaleFactorLatitude;
@property(nonatomic, assign) float iphoneScaleFactorLongitude;
@property(nonatomic, retain) MKAnnotationView *selViewForHouseImage;
@property(nonatomic, retain) MKAnnotationView *selViewForHouseImageInOut;
@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, assign) int numOfScrollViewSubviews;
@property(nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property(nonatomic, retain) IBOutlet UIImageView *calloutBubbleImg;
// @property(nonatomic, retain) IBOutlet UIButton *btShowFlatsWebView;
@property(nonatomic, retain) IBOutlet UILabel *lbPageNumber;
@property(nonatomic, retain) IBOutlet UIImageView *imgShadowTop;
@property(nonatomic, retain) IBOutlet UIImageView *imgShadowBottom;
@property(nonatomic, retain) Flat *sameFlat;
@property(nonatomic, assign) MKCoordinateSpan regionSpan;

- (void)calloutBubbleOut;
- (void)recenterMap;
- (void)calloutBubbleIn;
- (IBAction)showAllFlats;
- (void)stopSpinnerAnimation;
- (IBAction)showList;
- (IBAction)showMap;
- (IBAction)closeBubble;

- (void)setAnnotationImageAtAnnotation:(Flat *)_flat;
- (UILabel *)setLbNumberOfFlatsAtFlat:(Flat *)_flat;
- (void)filterAnnotations:(NSArray *)_flatsToFilter;
- (void)initScrollView;
- (UIView *)createCalloutBubbleContentFromFlat:(Flat *)_flat atPosition:(int)_pos;

@end
