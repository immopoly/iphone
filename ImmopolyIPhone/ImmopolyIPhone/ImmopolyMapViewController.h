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

#define METERS_PER_MILE 1609.344

@interface ImmopolyMapViewController : UIViewController <LocationDelegate, MKMapViewDelegate> {
    MKMapView *mapView;
    WebViewController *exposeWebViewController;
    LoginViewController *loginViewController;
    UserProfileViewController *userProfileViewController;
    PortfolioViewController *portfolioViewController;
    IBOutlet UILabel *adressLabel;
}

@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) IBOutlet UILabel *adressLabel;

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view;

// linked to compass button 
-(IBAction)refreshLocation;

//linked to user profile button
-(IBAction) displayUserProfile;

//linked to portfolio button
-(IBAction) displayUserPortfolio;

@end
