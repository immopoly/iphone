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
#import "AsynchronousImageView.h"

@implementation ImmopolyMapViewController 

@synthesize mapView, adressLabel, calloutBubble,selectedExposeId, lbFlatName, lbFlatDescription, lbFlatPrice, lbNumberOfRooms, lbLivingSpace,selectedImmoScoutFlat, isCalloutBubbleIn, isOutInCall, selViewForHouseImage, asyncImageView, iphoneScaleFactorLatitude, iphoneScaleFactorLongitude, scrollView;

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
    
    // calculation for clustering
    CGFloat scrWidth = CGRectGetWidth(self.view.bounds);
    CGFloat scrHeight = CGRectGetHeight(self.view.bounds);    
    iphoneScaleFactorLatitude = (float) scrWidth/ANNO_WIDTH;
    iphoneScaleFactorLongitude = (float) scrHeight/ANNO_HEIGHT;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    CGPoint pos = calloutBubble.center;
	pos.y = -320.0f;
	calloutBubble.center = pos;
	
    [mapView setZoomEnabled:YES];
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
}

- (void) displayFlatsOnMap {
    
    // removing all existing annotations
    for (id<MKAnnotation> annotation in mapView.annotations) {
        // check that the my location annotion does not get removed
        if([annotation isKindOfClass:[Flat class]]){    
            [mapView removeAnnotation:annotation];
        }
    }     
    
    [self mapView:mapView regionDidChangeAnimated:YES];
    
    /*
    for(Flat *flat in [[ImmopolyManager instance] immoScoutFlats]) {
        [mapView addAnnotation: flat];
    }
    */ 
}

- (void)mapView:(MKMapView *)mpView didSelectAnnotationView:(MKAnnotationView *)view{
    
    if(isCalloutBubbleIn){
        [self setIsOutInCall:YES];
        [self calloutBubbleOut];
    }
    if([view.annotation isKindOfClass:[Flat class]]) {
        [self setSelViewForHouseImage:view];
        Flat *location = (Flat *) view.annotation;
        [self setSelectedExposeId:[location exposeId]];
        [self setSelectedImmoScoutFlat:location]; 
          
        // TODO: zoom has to be changed, because for clustering it doesn't make sense 
        // moving the coordinates, that it doesn't zoom to the center, but a bit under it 
        CLLocationCoordinate2D zoomLocation = location.coordinate;
        zoomLocation.latitude = zoomLocation.latitude + 0.003;
        zoomLocation.longitude = zoomLocation.longitude + 0.0006;
         
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.3*METERS_PER_MILE, 0.3*METERS_PER_MILE);
        MKCoordinateRegion adjustedRegion = [mpView regionThatFits:viewRegion];                
        [mpView setRegion:adjustedRegion animated:YES];   
        
        if (!isOutInCall) {
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
        Flat *location = (Flat *) annotation;
        if([[location flatsAtAnnotation] count] > 0 ) {
            annotationView.image = [UIImage imageNamed:@"house_orange.png"];
        }
        else {
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

- (void)calloutBubbleIn {
    // that the flats are clickable through the imageview
    [mapView addSubview:calloutBubble];
    
    // setting text of labels in calloutBubble
    [lbFlatName setText:[selectedImmoScoutFlat name]];
    NSString *rooms = [NSString stringWithFormat:@"Zimmer: %d",[selectedImmoScoutFlat numberOfRooms]];
    NSString *space = [NSString stringWithFormat:@"Fläche: %f qm",[selectedImmoScoutFlat livingSpace]];
    NSString *price = [NSString stringWithFormat:@"Preis: %f €",[selectedImmoScoutFlat price]];
   
    // setting the image
    [asyncImageView loadImageFromURLString:[selectedImmoScoutFlat pictureUrl]];
    
    // TODO: cutting the 0 in a better way
    space = [space substringToIndex:[space length]-7];
    price = [price substringToIndex:[price length]-6];
    
    [lbFlatPrice setText:price];
    [lbNumberOfRooms setText:rooms];
    [lbLivingSpace setText:space];
    // TODO: title should not be like description
    [lbFlatDescription setText:[selectedImmoScoutFlat title]];
    
     
    // Animation
    [UIView beginAnimations:@"inAnimation" context:NULL];	
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];    
	[UIView setAnimationDuration:0.4];
	
	CGPoint pos = calloutBubble.center;
	pos.y = 160.0f;
	calloutBubble.center = pos;
	
    [UIView commitAnimations]; 
    [self setIsCalloutBubbleIn:true];
    [mapView deselectAnnotation:selectedImmoScoutFlat animated:NO];    
    selViewForHouseImage.image = [UIImage imageNamed:@"house_green_selected.png"];
    [mapView setZoomEnabled:NO];
}

- (IBAction)calloutBubbleOut {
    
    [UIView beginAnimations:@"outAnimation" context:NULL];	
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
	CGPoint pos = calloutBubble.center;
	pos.y = -320;
	calloutBubble.center = pos;
	
    [UIView commitAnimations];
    [self setIsCalloutBubbleIn:false];
    [asyncImageView resetImage];
    
    if([[selectedImmoScoutFlat flatsAtAnnotation] count] > 0) {
        selViewForHouseImage.image = [UIImage imageNamed:@"house_orange.png"];
    } else {
        selViewForHouseImage.image = [UIImage imageNamed:@"house_green.png"];
    }
    [mapView setZoomEnabled:YES];
}

-(void)animationDidStop:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    if([animationID isEqualToString:@"inAnimation"]){
        NSLog(@"animation in");
    } else if([animationID isEqualToString:@"outAnimation"]) {
        NSLog(@"animation out");
        [calloutBubble removeFromSuperview];
        // checks wether it was called due the calloutBubble was inside the view
        if(isOutInCall){
            [self calloutBubbleIn];
            [self setIsOutInCall:NO];
        }
    }
}

-(IBAction)showFlatsWebView {
    exposeWebViewController = [[WebViewController alloc]init];
    [exposeWebViewController setSelectedImmoscoutFlat:[self selectedImmoScoutFlat]];
    [self.view addSubview:exposeWebViewController.view];
}

// method for clustering
-(void)filterAnnotations:(NSArray *)flatsToFilter {
    float latDelta = mapView.region.span.latitudeDelta/iphoneScaleFactorLatitude;
    float longDelta = mapView.region.span.longitudeDelta/iphoneScaleFactorLongitude;
    
    NSMutableArray *flatsToShow=[[NSMutableArray alloc] initWithCapacity:0];

    // resetting the flatsAtAnnotation array
    for (Flat *tempFlat in flatsToFilter) {
        [[tempFlat flatsAtAnnotation] removeAllObjects];
    }
    
    for (int i=0; i<[flatsToFilter count]; i++) {
        Flat *actFlat = [flatsToFilter objectAtIndex:i];
        CLLocationDegrees latitude = [actFlat coordinate].latitude;
        CLLocationDegrees longitude = [actFlat coordinate].longitude;
        
        bool found = FALSE;
        
        for (Flat *tempFlat in flatsToShow) {
            // überprüfe ob die akktuelle flat in der Nähe einer der Flats ist, welche
            // angezeigt werden sollen
            if(fabs([tempFlat coordinate].latitude-latitude) < latDelta &&
               fabs([tempFlat coordinate].longitude-longitude) <longDelta ) {
                
                // wenn gefunden, dann remove die aktuelle flat von der view
                [mapView removeAnnotation:actFlat];
                found = TRUE;
                
                // adde aktuelle flat zur annotation der tempflat
                [[tempFlat flatsAtAnnotation] addObject:actFlat];
                break;
            }
        }
        // wenn keine flat in der nähe gefunden wurde, adde diese flat zur Liste aller flats,
        // die gezeigt werden und zeige die Annotation
        if(!found) {
            [flatsToShow addObject:actFlat];
            [mapView addAnnotation:actFlat];
        }
    }
    [flatsToShow release];

}

-(void)mapView:(MKMapView *)mpView regionDidChangeAnimated:(BOOL)animated{
    if (zoomLevel != mpView.region.span.longitudeDelta || animated) {
        [self filterAnnotations: [[ImmopolyManager instance] immoScoutFlats]];
        zoomLevel = mpView.region.span.longitudeDelta;
    }
}

-(void)initScrollView {
    
    for (int i=0; i<[[selectedImmoScoutFlat flatsAtAnnotation] count]; i++) {
        Flat *tempFlat = [[selectedImmoScoutFlat flatsAtAnnotation] objectAtIndex:i];
        
        UIView *subview = [self createCalloutBubbleContentFromFlat:tempFlat atPosition:i];
        
        [scrollView addSubview:subview];
        [subview release];
    }
    
    // setting the whole size of the scrollView
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [[selectedImmoScoutFlat flatsAtAnnotation] count], self.scrollView.frame.size.height);
}

-(UIView *)createCalloutBubbleContentFromFlat:(Flat *) flat atPosition:(int) pos {
    
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * pos;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    
    UIView *subview = [[UIView alloc] initWithFrame:frame];
    subview.backgroundColor = [UIColor colorWithRed:0.1*pos green:0 blue:0 alpha:1];
    
    return subview;
}

@end
