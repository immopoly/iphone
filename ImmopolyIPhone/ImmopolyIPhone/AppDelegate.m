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

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

@synthesize CLController, isLocationUpdated;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [CLController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //OAuthManager *manager = [[OAuthManager alloc] init];
    //NSString *url = @"http://rest.immobilienscout24.de/restapi/api/search/v1.0/region?q=Ber";
    
    //[manager grabURLInBackground:url withFormat:@"application/json" withDelegate:self];
//    [manager release];
    
    // for getting the phone coordinates
    [self startLocationUpdate];
     
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[ImmopolyMapViewController alloc] init];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

// for getting the phone coordinates
- (void)startLocationUpdate {
    CLController = [[CoreLocationController alloc] init];
    CLController.delegate = self;
    [CLController.locMgr startUpdatingLocation];
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
    NSLog(@"Your location is: %@", [location description]);
    
    
    if (!isLocationUpdated) {
        FlatProvider *provider = [[FlatProvider alloc]init];
        [provider getFlatsFromLocation:[location coordinate]];
        
        [[ImmopolyManager instance]setActLocation:location];
        
        [[ImmopolyManager instance].delegate displayCurrentLocation];
        
    }
//    isLocationUpdated = YES;
    [CLController.locMgr stopUpdatingLocation];
    
}

- (void)locationError:(NSError *)error {
    NSLog(@"Your location not available!");
}

@end
