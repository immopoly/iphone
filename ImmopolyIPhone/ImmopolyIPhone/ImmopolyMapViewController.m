//
//  ImmopolyMapViewController.m
//  libOAuthDemo
//
//  Created by Maria Guseva on 26.10.11.
//  Copyright (c) 2011 Immobilienscout24. All rights reserved.
//

#import "ImmopolyMapViewController.h"
#import "FlatLocation.h"
#import "ImmopolyManager.h"
#import "Flat.h"
#import "AppDelegate.h"
#import "UserLoginTask.h"

@implementation ImmopolyMapViewController

@synthesize mapView, adressLabel;

-(void)dealloc{
    [super dealloc];
    [exposeWebViewController release];
    [loginViewController release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {  
    // 1
    
    CLLocationCoordinate2D zoomLocation = [[[ImmopolyManager instance]actLocation]coordinate];
    
    //zoomLocation.latitude = 52.521389; //39.281516;
    //zoomLocation.longitude = 13.411944; //-76.580806;
    // 2
    //MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.3*METERS_PER_MILE, 0.3*METERS_PER_MILE);
    // 3
    //MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
    // 4
    //[mapView setRegion:adjustedRegion animated:YES]; 
    
   // [self displayFlatsOnMap];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [ImmopolyManager instance].delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) displayCurrentLocation {
    CLLocationCoordinate2D zoomLocation = [[[ImmopolyManager instance]actLocation]coordinate];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.3*METERS_PER_MILE, 0.3*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
    [mapView setRegion:adjustedRegion animated:YES]; 
    
    FlatLocation *annotation = [[[FlatLocation alloc] initWithName:@"My Location" address:@"" coordinate:zoomLocation exposeId:-1] autorelease];
    [mapView addAnnotation: annotation];
}

- (void) displayFlatsOnMap {
    
    // removing all existing annotations
    for (id<MKAnnotation> annotation in mapView.annotations) {
        // check that the my location annotion does not get removed
        if([annotation isKindOfClass:[FlatLocation class]] && ![((FlatLocation *)annotation).title isEqualToString:@"My Location"]){
            [mapView removeAnnotation:annotation];
        }
    }     
    
    for(Flat *flat in [ImmopolyManager instance].ImmoScoutFlats) {
        
        
        NSNumber * latitude = [[NSNumber alloc] initWithDouble: flat.lat];
        NSNumber * longitude = [[NSNumber alloc] initWithDouble: flat.lng];
        NSString * title = flat.name;
        //NSString * address = flat.address;
        
        
        /*NSNumber * latitude = [NSNumber numberWithFloat: 52.521389];
        NSNumber * longitude = [NSNumber numberWithFloat: 13.411944];
        NSString * title = [NSString stringWithFormat: @"Zentrale Lage mit allem pipapo"];
        NSString * address = [NSString stringWithFormat: @"Alexanderplatz 13"];*/
    
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;            
        FlatLocation *annotation = [[[FlatLocation alloc] initWithName:title address:@"" coordinate:coordinate exposeId:flat.uid] autorelease];

        [mapView addAnnotation: annotation];
    
        //place another one
        /*latitude = [NSNumber numberWithFloat: 52.521111];
        longitude = [NSNumber numberWithFloat: 13.41];
        title = [NSString stringWithFormat: @"Mitten in der Stadt"];
        address = [NSString stringWithFormat: @"Panoramastraße 1"];
    
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;            
        annotation = [[[FlatLocation alloc] initWithName:title address:address coordinate:coordinate] autorelease];
        [mapView addAnnotation: annotation];
        */
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    if([view.annotation isKindOfClass:[FlatLocation class]]) {
        FlatLocation *location = (FlatLocation *) view.annotation;
        
        if (![location.title compare:@"My Location"] == NSOrderedSame) {
            //[[ImmopolyManager instance]setSelectedExposeId:location.exposeId];
            
            exposeWebViewController = [[WebViewController alloc]init];
            [exposeWebViewController setSelectedExposeId:[location exposeId]];
            [self.view addSubview:exposeWebViewController.view];
        }
        
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"FlatLocation";
    
    if([annotation isKindOfClass:[FlatLocation class]]) {
        FlatLocation *location = (FlatLocation *) annotation;
     
        MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
             
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
     
        //Color
        
        if([location.title compare:@"My Location"] == NSOrderedSame) {
            annotationView.pinColor = MKPinAnnotationColorGreen;
        }
        else {
            annotationView.pinColor = MKPinAnnotationColorRed;
        }
        
        return annotationView;
    }
     
    return nil;
}

// action for the compass button
- (IBAction)refreshLocation {
    AppDelegate *delegate = [(AppDelegate *)[UIApplication sharedApplication] delegate];
    [delegate startLocationUpdate];
    
}

/*
-(IBAction) displayUserProfile {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"userToken"] != nil) {
        //get user token
        NSString *userToken = [defaults objectForKey:@"userToken"];
        //login with token
        UserLoginTask *loader = [[UserLoginTask alloc] init];
        [loader performLoginWithToken: userToken];
        
        //wrong place to check
        if([ImmopolyManager instance].loginSuccessful == YES) {
            //show user profile view
            userProfileViewController = [[UserProfileViewController alloc] init];
            [self.view addSubview: userProfileViewController.view];
        }
        
        [loader release];
    }
    else {
        //show login view
        loginViewController = [[LoginViewController alloc] init];
        [self.view addSubview: loginViewController.view];
    }
}

-(IBAction) displayUserPortfolio {
    portfolioViewController = [[PortfolioViewController alloc] init];
    [self.view addSubview: portfolioViewController.view];
}
*/

@end
