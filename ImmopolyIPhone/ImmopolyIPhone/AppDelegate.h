//
//  AppDelegate.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "CoreLocationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate, CoreLocationControllerDelegate> {
    
    // for getting phone coordinates
    CoreLocationController *CLController;
    CLGeocoder *geocoder;
}

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) UITabBarController *tabBarController;

@property(nonatomic, retain) CoreLocationController *CLController;
@property(nonatomic, retain) CLGeocoder *geocoder;
@property(nonatomic, retain) IBOutlet UILabel *adressLabel;

- (void) startLocationUpdate;
- (void) geocodeLocation:(CLLocation *)location;

@end
