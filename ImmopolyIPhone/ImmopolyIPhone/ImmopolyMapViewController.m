//
//  ImmopolyMapViewController.m
//  libOAuthDemo
//
//  Created by Maria Guseva on 26.10.11.
//  Copyright (c) 2011 Immobilienscout24. All rights reserved.
//

#import "ImmopolyMapViewController.h"
#import "ImmopolyManager.h"
#import "Flat.h"
#import "AppDelegate.h"
#import "UserLoginTask.h"

@implementation ImmopolyMapViewController

@synthesize mapView, adressLabel, calloutBubble,selectedExposeId;

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
    
    // that only the background is transparent and not the whole view
    calloutBubble.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
   
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

-(void) setAdressLabelText:(NSString *)locationName {
    [adressLabel setText:locationName];
}

-(void) displayCurrentLocation {
    CLLocationCoordinate2D zoomLocation = [[[ImmopolyManager instance]actLocation]coordinate];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.3*METERS_PER_MILE, 0.3*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
    [mapView setRegion:adjustedRegion animated:YES]; 
    
    Flat *myLocation = [[[Flat alloc] initWithName:@"My Location" description:@"" coordinate:zoomLocation exposeId:-1] autorelease];

    [mapView addAnnotation: myLocation];
}

- (void) displayFlatsOnMap {
    
    // removing all existing annotations
    for (id<MKAnnotation> annotation in mapView.annotations) {
        // check that the my location annotion does not get removed
        if([annotation isKindOfClass:[Flat class]] && ![((Flat *)annotation).title isEqualToString:@"My Location"]){    
            [mapView removeAnnotation:annotation];
        }
    }     
    
    for(Flat *flat in [ImmopolyManager instance].ImmoScoutFlats) {
        [mapView addAnnotation: flat];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
      if([view.annotation isKindOfClass:[Flat class]]) {
        Flat *location = (Flat *) view.annotation;
        [self setSelectedExposeId:[location exposeId]]; 
        
        if (![location.title compare:@"My Location"] == NSOrderedSame) {
            //[[ImmopolyManager instance]setSelectedExposeId:location.exposeId];
            
            [self calloutBubbleIn];
        }
        
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"Flat";  
    
    if([annotation isKindOfClass:[Flat class]]) {
        Flat *location = (Flat *) annotation;
        
        MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
             
        annotationView.enabled = YES;
        
        // NO, because our own bubble is coming in
        annotationView.canShowCallout = NO;
     
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

- (IBAction)calloutBubbleIn {
    [UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.4];
	
	CGPoint pos = calloutBubble.center;
	pos.x = 160.0f;
	calloutBubble.center = pos;
	
    [UIView commitAnimations]; 
}

- (IBAction)calloutBubbleOut {
    [UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.4];
	
	CGPoint pos = calloutBubble.center;
	pos.x = 445.0f;
	calloutBubble.center = pos;
	
    [UIView commitAnimations]; 
}

-(IBAction)showFlatsWebView {
    exposeWebViewController = [[WebViewController alloc]init];
    [exposeWebViewController setSelectedExposeId:[self selectedExposeId]];
    [self.view addSubview:exposeWebViewController.view];
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
