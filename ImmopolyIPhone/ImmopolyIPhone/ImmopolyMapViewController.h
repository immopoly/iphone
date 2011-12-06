//
//  ImmopolyMapViewController.h
//  libOAuthDemo
//
//  Created by Maria Guseva on 26.10.11.
//  Copyright (c) 2011 Immobilienscout24. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationDelegate.h"
#import "WebViewController.h"
#import "LoginViewController.h"
#import "UserProfileViewController.h"
#import "PortfolioViewController.h"
#import "Flat.h"

#define METERS_PER_MILE 1609.344
#define ANNO_WIDTH 33
#define ANNO_HEIGHT 30

@interface ImmopolyMapViewController : UIViewController <LocationDelegate, MKMapViewDelegate, UIPageViewControllerDelegate> {
    MKMapView *mapView;
    WebViewController *exposeWebViewController;
    LoginViewController *loginViewController;
    UserProfileViewController *userProfileViewController;
    PortfolioViewController *portfolioViewController;
    IBOutlet UILabel *adressLabel;
    IBOutlet UILabel *lbFlatName;
    IBOutlet UILabel *lbFlatDescription;
    IBOutlet UILabel *lbFlatPrice;
    IBOutlet UILabel *lbNumberOfRooms;
    IBOutlet UILabel *lbLivingSpace;
    
    IBOutlet UIView *calloutBubble;
    bool isCalloutBubbleIn;
    bool isOutInCall;
    int selectedExposeId;
    Flat *selectedImmoScoutFlat;
    MKAnnotationView *selViewForHouseImage;
    IBOutlet AsynchronousImageView *asyncImageView;
    
    // variables vor clustering
    float iphoneScaleFactorLatitude;
    float iphoneScaleFactorLongitude;
    CLLocationDegrees zoomLevel;
    IBOutlet UIScrollView *scrollView;
    int numOfScrollViewSubviews;
    
    IBOutlet UIPageControl *pageControl;
}

@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) IBOutlet UILabel *adressLabel;
@property(nonatomic, retain) IBOutlet UILabel *lbFlatName;
@property(nonatomic, retain) IBOutlet UILabel *lbFlatDescription;
@property(nonatomic, retain) IBOutlet UILabel *lbFlatPrice;
@property(nonatomic, retain) IBOutlet UILabel *lbNumberOfRooms;
@property(nonatomic, retain) IBOutlet UILabel *lbLivingSpace;
@property (nonatomic, retain) UIView *calloutBubble;
@property (nonatomic, assign) int selectedExposeId;
@property(nonatomic, retain) Flat *selectedImmoScoutFlat;
@property(nonatomic, assign) bool isCalloutBubbleIn;
@property(nonatomic, assign) bool isOutInCall;
@property(nonatomic, retain) MKAnnotationView *selViewForHouseImage;
@property(nonatomic, retain) IBOutlet AsynchronousImageView *asyncImageView;
@property(nonatomic, assign) float iphoneScaleFactorLatitude;
@property(nonatomic, assign) float iphoneScaleFactorLongitude;
@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, assign) int numOfScrollViewSubviews;
@property(nonatomic, retain) IBOutlet UIPageControl *pageControl;

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view;

// linked to compass button 
-(IBAction)refreshLocation;

-(void)calloutBubbleIn;
-(IBAction)calloutBubbleOut;
-(void)showFlatsWebView;
-(void)animationDidStop:(NSString *)animationID finished:(BOOL)finished context:(void *)context;
-(void)filterAnnotations:(NSArray *)flatsToFilter;

-(void)initScrollView;
-(UIView *)createCalloutBubbleContentFromFlat:(Flat *) flat atPosition:(int) pos;

@end
