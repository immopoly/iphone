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
#import "AbstractMapViewController.h"

//#define METERS_PER_MILE 50000.00

@interface ImmopolyMapViewController : AbstractMapViewController <LocationDelegate> {
    IBOutlet UILabel *adressLabel;
    IBOutlet UIButton *actualiseButton;
}

@property(nonatomic, strong) IBOutlet UILabel *adressLabel;
@property(nonatomic, strong) IBOutlet UIButton *actualiseButton;

@end