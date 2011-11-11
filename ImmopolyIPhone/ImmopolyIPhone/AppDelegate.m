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

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

@synthesize CLController, geocoder;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [CLController release];
    [super dealloc];
}

-(void)handleHistoryResponse:(NSNotification *)notification {
    HistoryEntry *histEntry= [[notification userInfo] valueForKey:@"histEntry"];
    
    UIAlertView *infoAlert = [[UIAlertView alloc]initWithTitle:@"Info" message:[histEntry histText] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [infoAlert show];
    [infoAlert release];
}

-(void)handleErrorMsg:(NSNotification *)notification {
    NSError *err= [[notification userInfo] valueForKey:@"error"];
    
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:[MessageHandler giveErrorMsg:[err code]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [errorAlert show];
    [errorAlert release];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self startLocationUpdate];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    ImmopolyMapViewController *mapVC;
    PortfolioViewController *portfolioVC;
    LoginViewController *loginVC;
    HistoryViewController *historyVC;
    
    mapVC = [[[ImmopolyMapViewController alloc]init]autorelease];
    portfolioVC = [[[PortfolioViewController alloc]init]autorelease];
    loginVC = [[[LoginViewController alloc]init]autorelease];    
    historyVC = [[[HistoryViewController alloc]init]autorelease];    
    
    self.tabBarController = [[[UITabBarController alloc]init]autorelease];
    
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:mapVC,portfolioVC,loginVC,historyVC, nil];
    self.window.rootViewController = self.tabBarController;

    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHistoryResponse:) name:@"portfolio/add" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleErrorMsg:) name:@"portfolio/add fail" object:nil];

    
    return YES;
}

// method for getting the phone coordinates
- (void)startLocationUpdate {
    CLController = [[CoreLocationController alloc] init];
    CLController.delegate = self;
    [CLController.locMgr startUpdatingLocation];
}

// method for converting lat and long from location to user friendly address
- (void)geocodeLocation:(CLLocation *)location{
    
    if (!geocoder){    
        geocoder = [[CLGeocoder alloc] init];
    }
    
    [geocoder reverseGeocodeLocation:location completionHandler:
     //block object
     ^(NSArray* placemarks, NSError* error){
         
         // TODO: check for error
         
         if ([placemarks count] > 0){
             CLPlacemark *placemark = [placemarks lastObject];
             NSLog(@"Your current location is %@",[placemark name]);
             
             // TODO: change label in mapviewcontroller
             [[ImmopolyManager instance].delegate setAdressLabelText:[placemark name]];
         }
     }];
}

- (void) setAdressLabel:(UILabel *)adressLabel{
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

// methods for getting phone coordinates
- (void)locationUpdate:(CLLocation *)location {
    
    [self geocodeLocation:location];
    
    FlatProvider *provider = [[FlatProvider alloc]init];
    [provider getFlatsFromLocation:[location coordinate]];
        
    [[ImmopolyManager instance]setActLocation:location];
    [[ImmopolyManager instance].delegate displayCurrentLocation];
            
    [CLController.locMgr stopUpdatingLocation];    
}

- (void)locationError:(NSError *)error {
    NSLog(@"Your location not available!");
}

@end
