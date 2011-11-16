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

@interface ImmopolyMapViewController : UIViewController <LocationDelegate, MKMapViewDelegate> {
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
    int selectedExposeId;
    Flat *selectedImmoScoutFlat;
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
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view;

// linked to compass button 
-(IBAction)refreshLocation;

-(IBAction)calloutBubbleIn;
-(IBAction)calloutBubbleOut;
-(IBAction)showFlatsWebView;



@end
