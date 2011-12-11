//
//  AppDelegate.m
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "OAuthManager.h"
#import "FlatProvider.h"
#import "ImmopolyManager.h"
#import "ImmopolyMapViewController.h"
#import "PortfolioViewController.h"
#import "LoginViewController.h"
#import "HistoryViewController.h"
#import "HistoryEntry.h"
#import "MessageHandler.h"
#import "UserProfileViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

@synthesize CLController;
@synthesize geocoder;
@synthesize adressLabel;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [CLController release];
    [super dealloc];
}

- (void)handleHistoryResponse:(NSNotification *)_notification {
    HistoryEntry *histEntry= [[_notification userInfo] valueForKey:@"histEntry"];
    
    UIAlertView *infoAlert = [[UIAlertView alloc]initWithTitle:@"Info" message:[histEntry histText] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [infoAlert show];
    [infoAlert release];
}

- (void)handleErrorMsg:(NSNotification *)_notification {
    NSError *err= [[_notification userInfo] valueForKey:@"error"];
    
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:[MessageHandler giveErrorMsg:err] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    [errorAlert release];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self startLocationUpdate];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    ImmopolyMapViewController *mapVC;
    PortfolioViewController *portfolioVC;
    //LoginViewController *loginVC;
    UserProfileViewController *userVC;
    HistoryViewController *historyVC;
    
    mapVC = [[[ImmopolyMapViewController alloc] init] autorelease];
    portfolioVC = [[[PortfolioViewController alloc] init] autorelease];
    //loginVC = [[[LoginViewController alloc]init]autorelease]; 
    userVC = [[[UserProfileViewController alloc] init] autorelease];
    historyVC = [[[HistoryViewController alloc] init] autorelease];    
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:mapVC,portfolioVC,userVC,historyVC, nil];
    self.window.rootViewController = self.tabBarController;

    [self.window makeKeyAndVisible];
    
    // observer for login of user error
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleErrorMsg:) name:@"user/login fail" object:nil];
    
    // observer for register of user error
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleErrorMsg:) name:@"user/register fail" object:nil];
    
    // observer for parsing flat data error
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleErrorMsg:) name:@"flatProvider/parse fail" object:nil];
    
    // observer for taking over a flat error
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHistoryResponse:) name:@"portfolio/add" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleErrorMsg:) name:@"portfolio/add fail" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHistoryResponse:) name:@"portfolio/remove" object:nil];
    
    [self enableAutomaticLogin];
    
    sleep(3);

    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [viewController viewWillAppear:YES];
}

// method for getting the phone coordinates
- (void)startLocationUpdate {
    CLController = [[CoreLocationController alloc] init];
    CLController.delegate = self;
    [CLController.locationManager startUpdatingLocation];
}

// method for converting lat and long from location to user friendly address
- (void)geocodeLocation:(CLLocation *)_location {
    
    if (!geocoder){    
        geocoder = [[CLGeocoder alloc] init];
    }
    
    [geocoder reverseGeocodeLocation:_location completionHandler:
     //block object
     ^(NSArray* placemarks, NSError* error){
         
         // TODO: check for error
         
         if ([placemarks count] > 0){
             CLPlacemark *placemark = [placemarks lastObject];
             NSLog(@"Your current location is %@",[placemark name]);
             
             // change label in mapviewcontroller
             [[ImmopolyManager instance].delegate setAdressLabelText:[placemark name]];
         }
     }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

// methods for getting phone coordinates
- (void)locationUpdate:(CLLocation *)_location {
    
    [self geocodeLocation:_location];
    
    FlatProvider *provider = [[FlatProvider alloc] init];
    [provider getFlatsFromLocation:[_location coordinate]];
    
    [[ImmopolyManager instance]setActLocation:_location];
    [[ImmopolyManager instance].delegate displayCurrentLocation];
            
    [CLController.locationManager stopUpdatingLocation];
}

- (void)locationError:(NSError *)_error {
    NSLog(@"Your location not available!");
}

- (void)enableAutomaticLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"YES" forKey:@"saveToken"];
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
}

@end
