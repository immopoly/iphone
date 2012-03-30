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
#import "FeedbackViewController.h"
#import "LoginCheck.h"
#import "AbstractViewController.h"

//HACK FOR 4.3
/*
@implementation CLLocationManager (TemporaryHack)

- (void)hackLocationFix
{
    CLLocation *fhain = [[CLLocation alloc] initWithLatitude:52.517527 longitude:13.469474];
    [[self delegate] locationManager:self didUpdateToLocation:fhain fromLocation:nil];     
}

- (void)startUpdatingLocation
{
    [self performSelector:@selector(hackLocationFix) withObject:nil afterDelay:0.1];
}

@end
//STOP HACK FOR 4.3
*/

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

@synthesize CLController;
@synthesize geocoder;
@synthesize adressLabel;

@synthesize selectedViewController;
@synthesize actualisationSpinner;
@synthesize isLocationUpdated;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [CLController release];
    [selectedViewController release];
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

- (void)handleTaskMessage:(NSNotification *) _notification {
    
    NSString *taskMessage = [[_notification userInfo] objectForKey:@"message"];
    UIAlertView *infoAlert = [[UIAlertView alloc]initWithTitle:@"Info" message:taskMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [infoAlert show];
    [infoAlert release];
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
    FeedbackViewController *feedbackVC;
    
    mapVC = [[[ImmopolyMapViewController alloc] init] autorelease];
    portfolioVC = [[[PortfolioViewController alloc] init] autorelease];
    //loginVC = [[[LoginViewController alloc]init]autorelease]; 
    userVC = [[[UserProfileViewController alloc] init] autorelease];
    historyVC = [[[HistoryViewController alloc] init] autorelease];    
    feedbackVC = [[[FeedbackViewController alloc]init]autorelease];
    
    self.tabBarController = [[[CustomTabBarController alloc] init] autorelease];
    self.tabBarController.delegate = self;
    
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:userVC,portfolioVC,mapVC,historyVC,feedbackVC, nil];
    [self.tabBarController addCenterButtonWithImage:[UIImage imageNamed:@"tabbar_center_icon.png"] highlightImage:[UIImage imageNamed:@"tabbar_center_icon_blue.png"]];
    [self.tabBarController setSelectedIndex:2];
    
    [self setSelectedViewController:[[self tabBarController]selectedViewController]];
    
    self.window.rootViewController = self.tabBarController;
    

    [self.window makeKeyAndVisible];
    
    // observer for login of user error
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleErrorMsg:) name:@"user/login fail" object:nil];
    
    // observer for register of user error
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleErrorMsg:) name:@"user/register fail" object:nil];
    
    // observer for register of user success
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTaskMessage:) name:@"user/register successful" object:nil];
    
    // observer for reset password error
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleErrorMsg:) name:@"user/reset password fail" object:nil];
    
    // observer for reset password success
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTaskMessage:) name:@"user/reset password successful" object:nil];
    
    // observer for parsing flat data error
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleErrorMsg:) name:@"flatProvider/parse fail" object:nil];
    
    // observer for taking over a flat error
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHistoryResponse:) name:@"portfolio/add" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleErrorMsg:) name:@"portfolio/add fail" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHistoryResponse:) name:@"portfolio/remove" object:nil];
    
    [self enableAutomaticLogin];

    sleep(3);
    
    [[self.tabBarController button] setBackgroundImage:[UIImage imageNamed:@"tabbar_center_icon_blue.png"] forState:UIControlStateNormal];
    
    return YES;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    [[self.tabBarController button] setBackgroundImage:[UIImage imageNamed:@"tabbar_center_icon.png"] forState:UIControlStateNormal];
    
    AbstractViewController *actViewController = (AbstractViewController*)[[self tabBarController]selectedViewController];
    if (([actViewController viewIsVisible])) {
        [actViewController helperViewOut];
    }
    
    [self setSelectedViewController:viewController];
    
    if([viewController class] == [FeedbackViewController class] || [viewController class] == [ImmopolyMapViewController class] || [[ImmopolyManager instance] loginSuccessful]) {
        return YES;
    }
    else {
        BOOL automaticLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"saveToken"];
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] != nil && automaticLogin) {
            return YES;
        }else{
            [self showLoginViewController];
        }
        
        //[self tryLoginWithToken];
        
        return NO;
    }
}

-(void) tryLoginWithToken {
    
    BOOL automaticLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"saveToken"];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] != nil && automaticLogin) {
        //get user token
        NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
        //login with token
        UserLoginTask *loader = [[[UserLoginTask alloc] init] autorelease];
        loader.delegate = self;
        [loader performLoginWithToken: userToken];
    }
    else {
        //show modal view controller
    }
}

-(void) loginWithResult:(BOOL)_result {
    
    [actualisationSpinner stopAnimating];
    [actualisationSpinner release];
    
    if(_result) {
        //[[self selectedViewController]viewWillAppear:YES];
        
        if ([selectedViewController isKindOfClass:[HistoryViewController class]]) {
            [(HistoryViewController *)selectedViewController setLoadingHistoryEntriesStart:10];
        }
        [self.tabBarController setSelectedViewController:selectedViewController];
    }
    else {
        [self showLoginViewController];
    }
}

- (void)notifyMyDelegateView {
    [self loginWithResult:YES];
}

- (void)closeMyDelegateView {
    [self.tabBarController setSelectedIndex:2];
    [[self tabBarController]centerClicked];
}

-(void) showLoginViewController {
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    loginVC.delegate = self;
    [self.tabBarController presentModalViewController: loginVC animated: YES];
    [loginVC release];
}


// method for getting the phone coordinates
- (void)startLocationUpdate {
    CLController = [[CoreLocationController alloc] init];
    CLController.delegate = self;
    [CLController.locationManager startUpdatingLocation];
}

// method for converting lat and long from location to user friendly address
- (void)geocodeLocation:(CLLocation *)_location {
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")){
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
    } else {
        MKReverseGeocoder* theGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:_location.coordinate];
        theGeocoder.delegate = self;
        [theGeocoder start]; 
        
    }    
}


- (void)reverseGeocoder:(MKReverseGeocoder*)geocoder didFindPlacemark:(MKPlacemark*)placemark {
    // change label in mapviewcontroller
    NSString *street = [placemark.addressDictionary valueForKey:@"Street"];
    NSLog(@"Your current location is %@",street);
    [[ImmopolyManager instance].delegate setAdressLabelText:street];
}

- (void)reverseGeocoder:(MKReverseGeocoder*)geocoder didFailWithError:(NSError*)error {
    NSLog(@"Could not retrieve the specified place information.\n");
}
 

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    if (![[ImmopolyManager instance]willComeBack]) {
        
        [[self tabBarController]centerClicked];
        [[ImmopolyManager instance]setLoginSuccessful:NO];
        [[[[ImmopolyManager instance]user]history]removeAllObjects];
        [[self.tabBarController.viewControllers objectAtIndex:1]dismissModalViewControllerAnimated:NO];
        [[self.tabBarController.viewControllers objectAtIndex:2]dismissModalViewControllerAnimated:NO];
        ((HistoryViewController *) [[[self tabBarController]viewControllers]objectAtIndex:3]).loadingHistoryEntriesStart=10;
        ((HistoryViewController *) [[[self tabBarController]viewControllers]objectAtIndex:3]).loading=NO;
        
        // removing all annotations from portfolioMapView that they don't get doubled
        UIViewController *vc = [[[self tabBarController]viewControllers]objectAtIndex:1];
        if ([vc isKindOfClass:[PortfolioViewController class]]) {
            MKMapView *mapView = [[[[self tabBarController]viewControllers]objectAtIndex:1] portfolioMapView];
            [mapView removeAnnotations:mapView.annotations];
        }        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"image"];
        
    }else{
        [[ImmopolyManager instance]setWillComeBack:NO];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    actualisationSpinner = [[UIActivityIndicatorView alloc] init];
    
    switch (buttonIndex) {
            //Nein
        case 0:
            
            break;
            //Ja                
        case 1:
            [actualisationSpinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
            
            
            CGPoint point;
            point.x = 300;
            point.y = 21;
            
            [[[self.tabBarController selectedViewController]view]addSubview:actualisationSpinner];
            [actualisationSpinner setCenter:point];
            [actualisationSpinner startAnimating];
            
            [self tryLoginWithToken];
            break;
            
        default:
            break;
    }   
    //[self.view removeFromSuperview];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    BOOL shouldLogout = [[NSUserDefaults standardUserDefaults] boolForKey:@"facebook_logout"];
    //delete User Profile Pic
    if(shouldLogout){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FBUserId"]; 
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"facebook-image"]; 
        
        UIViewController *vc = [[[self tabBarController]viewControllers]objectAtIndex:0];
        if ([vc isKindOfClass:[UserProfileViewController class]]) {
            [[[[[self tabBarController]viewControllers]objectAtIndex:0] userImage]reset];
            [[[[[self tabBarController]viewControllers]objectAtIndex:0] userImage]setHidden:YES];
        }        
    }
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
    
    if(!isLocationUpdated) {
        [self geocodeLocation:_location];
    
        FlatProvider *provider = [[FlatProvider alloc] init];
        [provider getFlatsFromLocation:[_location coordinate]];
    
        [[ImmopolyManager instance]setActLocation:_location];
        //[[ImmopolyManager instance].delegate displayCurrentLocation];
            
        [CLController.locationManager stopUpdatingLocation];
        
        [self setIsLocationUpdated:YES];
    }
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
