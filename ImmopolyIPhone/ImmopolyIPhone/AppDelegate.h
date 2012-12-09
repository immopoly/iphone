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
#import "CustomTabBarController.h"
#import "LoginCheck.h"
#import "ActionItemManager.h"
#import "FlatProvider.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate, CoreLocationControllerDelegate, UITabBarControllerDelegate, LoginDelegate, NotifyViewDelegate> {
    
    // for getting phone coordinates
    CoreLocationController *CLController;
    CLGeocoder *geocoder;
    LoginCheck *loginCheck;
    UIViewController *selectedViewController;
    UIActivityIndicatorView *actualisationSpinner;
    bool isLocationUpdated;
    ActionItemManager *actionItemManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CustomTabBarController *tabBarController;

@property(nonatomic, strong) CoreLocationController *CLController;
@property(nonatomic, strong) CLGeocoder *geocoder;
@property(nonatomic, strong) IBOutlet UILabel *adressLabel;

@property(nonatomic, strong) UIViewController *selectedViewController;
@property(nonatomic, strong) UIActivityIndicatorView *actualisationSpinner;
@property(nonatomic, assign) bool isLocationUpdated;

@property(nonatomic, strong) FlatProvider *provider;

@property(nonatomic, strong) ActionItemManager *actionItemManager;

- (void)startLocationUpdate;
- (void)geocodeLocation:(CLLocation *)_location;
- (void)handleHistoryResponse:(NSNotification *)_notification;
- (void)handleErrorMsg:(NSNotification *)_notification;
- (void)handleTaskMessage:(NSNotification *) _notification;
- (void)enableAutomaticLogin;

-(void) showLoginViewController;
-(void) tryLoginWithToken;

@end
