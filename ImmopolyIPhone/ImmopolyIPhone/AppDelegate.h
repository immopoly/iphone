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

//@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate, CoreLocationControllerDelegate> {
    
    // for getting phone coordinates
    CoreLocationController *CLController;
    BOOL isLocationUpdated;
}

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) UITabBarController *tabBarController;

//@property (retain, nonatomic) ImmopolyMapViewController *viewController;
@property(nonatomic, retain) CoreLocationController *CLController;
@property(nonatomic, assign) BOOL isLocationUpdated;

-(void)startLocationUpdate;


@end
