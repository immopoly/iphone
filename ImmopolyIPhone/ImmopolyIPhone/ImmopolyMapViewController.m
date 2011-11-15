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

@synthesize mapView, adressLabel, calloutBubble,selectedExposeId, lbFlatName, lbFlatDescription, lbFlatPrice, lbNumberOfRooms, lbLivingSpace;

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
        self.title = NSLocalizedString(@"Map", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"tab_map"];
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

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // that only the background is transparent and not the whole view
    calloutBubble.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
   
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
    
    for(Flat *flat in [[ImmopolyManager instance] immoScoutFlats]) {
        [mapView addAnnotation: flat];
    }
}

- (void)mapView:(MKMapView *)mpView didSelectAnnotationView:(MKAnnotationView *)view{
    
      if([view.annotation isKindOfClass:[Flat class]]) {
        Flat *location = (Flat *) view.annotation;
        [self setSelectedExposeId:[location exposeId]];
          
          // moving the coordinates, that it doesn't zoom to the center, but a bit under it 
          CLLocationCoordinate2D zoomLocation = location.coordinate;
          zoomLocation.latitude = zoomLocation.latitude + 0.003;
          zoomLocation.longitude = zoomLocation.longitude + 0.0006;
          
          MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.3*METERS_PER_MILE, 0.3*METERS_PER_MILE);
          MKCoordinateRegion adjustedRegion = [mpView regionThatFits:viewRegion];                
          [mpView setRegion:adjustedRegion animated:YES];   
        
        if (![location.title compare:@"My Location"] == NSOrderedSame) {
            
            // setting text of labels in calloutBubble
            [lbFlatName setText:[location name]];
            NSString *rooms = [NSString stringWithFormat:@"Zimmer: %d",[location numberOfRooms]];
            NSString *space = [NSString stringWithFormat:@"Fläche: %f qm",[location livingSpace]];
            NSString *price = [NSString stringWithFormat:@"Preis: %f €",[location price]];
            
            // cutting the 0
            space = [space substringToIndex:[space length]-7];
            price = [price substringToIndex:[price length]-6];
            
            [lbFlatPrice setText:price];
            [lbNumberOfRooms setText:rooms];
            [lbLivingSpace setText:space];
            // TODO: title should not be like description
            [lbFlatDescription setText:[location title]];
            
           // [price release];
           // [rooms release];
           // [space release];
            [self calloutBubbleIn];
        }
        
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"Flat";  
    
    if([annotation isKindOfClass:[Flat class]]) {
        
        MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
             
        annotationView.enabled = YES;
        
        // NO, because our own bubble is coming in
        annotationView.canShowCallout = NO;
     
     
        // checks that annotation is not the current position    
        if([annotation.title compare:@"My Location"] != NSOrderedSame) {
            annotationView.image = [UIImage imageNamed:@"house_green.png"];
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
	pos.y = 230.0f;
	calloutBubble.center = pos;
	
    [UIView commitAnimations]; 
}

- (IBAction)calloutBubbleOut {
    [UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.4];
	
	CGPoint pos = calloutBubble.center;
	pos.y = -292.0f;
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
