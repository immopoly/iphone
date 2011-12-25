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

@synthesize mapView;
@synthesize adressLabel;
@synthesize calloutBubble;
@synthesize selectedExposeId;
@synthesize lbFlatName;
@synthesize lbFlatDescription;
@synthesize lbFlatPrice;
@synthesize lbNumberOfRooms;
@synthesize lbLivingSpace;
@synthesize lbPageNumber;
@synthesize selectedImmoScoutFlat;
@synthesize isCalloutBubbleIn;
@synthesize isOutInCall;
@synthesize showCalloutBubble;
@synthesize selViewForHouseImage;
@synthesize selViewForHouseImageInOut;
@synthesize asyncImageView;
@synthesize iphoneScaleFactorLatitude;
@synthesize iphoneScaleFactorLongitude;
@synthesize scrollView;
@synthesize numOfScrollViewSubviews;
@synthesize pageControl;
@synthesize calloutBubbleImg;
// @synthesize btShowFlatsWebView;
@synthesize sameFlat;

-(void)dealloc {
    [super dealloc];
    [exposeWebViewController release];
    [loginViewController release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
        self.title = NSLocalizedString(@"Map", @"First");
        self.tabBarItem.image = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {  
    // hiding calloutBubble when the user returns from another tab
    [calloutBubble removeFromSuperview];
    [self setShowCalloutBubble:NO];
    [lbPageNumber setHidden:YES];
//    [btShowFlatsWebView setHidden:YES];
    
    // showing the annotation imgae
    [selViewForHouseImage setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [calloutBubbleImg setHidden:YES];
    [lbPageNumber setHidden:YES];
//    [btShowFlatsWebView setHidden:YES];
    [self setShowCalloutBubble:NO];
    
    // that only the background is transparent and not the whole view
    calloutBubble.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
   
    [ImmopolyManager instance].delegate = self;
    
    // calculation for clustering
    CGFloat scrWidth = CGRectGetWidth(self.view.bounds);
    CGFloat scrHeight = CGRectGetHeight(self.view.bounds);    
    iphoneScaleFactorLatitude = (float) scrWidth/ANNO_WIDTH;
    iphoneScaleFactorLongitude = (float) scrHeight/ANNO_HEIGHT;
    [self setNumOfScrollViewSubviews:0];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.adressLabel = nil;
    self.lbFlatName = nil;
    self.lbFlatDescription = nil;
    self.lbFlatPrice = nil;
    self.lbNumberOfRooms = nil;
    self.lbLivingSpace = nil;
    self.lbPageNumber = nil;
    self.calloutBubble = nil;
    self.asyncImageView = nil;
    self.scrollView = nil;
    self.pageControl = nil;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [mapView setZoomEnabled:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setAdressLabelText:(NSString *)_locationName {
    [adressLabel setText:_locationName];
}

- (void)displayCurrentLocation {
    CLLocationCoordinate2D zoomLocation = [[[ImmopolyManager instance]actLocation]coordinate];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.3*METERS_PER_MILE, 0.3*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
    [mapView setRegion:adjustedRegion animated:YES]; 
}

- (void) displayFlatsOnMap {
    
    // removing all existing annotations
    for (id<MKAnnotation> annotation in mapView.annotations) {
        if([annotation isKindOfClass:[Flat class]]){    
            [mapView removeAnnotation:annotation];
        }
    }     
    
    // gets called that the filter is running and the flats are shown at the view
    [self filterAnnotations: [[ImmopolyManager instance] immoScoutFlats]];
}

- (void)mapView:(MKMapView *)mpView didSelectAnnotationView:(MKAnnotationView *)view{

    if(isCalloutBubbleIn){
        [self setIsOutInCall:YES];
        [self calloutBubbleOut];
        
        if([view.annotation isKindOfClass:[Flat class]]) {
            // that the right annotation gets shown, whenn an outIn call is happening
            [self setSelViewForHouseImageInOut:selViewForHouseImage];
            [self setSelViewForHouseImage:view];
            
            Flat *location = (Flat *) view.annotation;
            [self setSelectedImmoScoutFlat:location]; 
            sameFlat = location;
        }
    }
    else {
        if([view.annotation isKindOfClass:[Flat class]]) {
            [self setSelViewForHouseImage:view];
            Flat *location = (Flat *) view.annotation;
            [self setSelectedImmoScoutFlat:location]; 
                        
            // moving the view to the center where the selected flat is placed
            CLLocationCoordinate2D zoomLocation = location.coordinate;
            MKCoordinateRegion viewRegion = MKCoordinateRegionMake(zoomLocation, mpView.region.span);
            MKCoordinateRegion adjustedRegion = [mpView regionThatFits:viewRegion];                
            [mpView setRegion:adjustedRegion animated:YES];   
            
            // calloutBubbleIn gets called at regionDidChanged, when bool showCalloutBubble is true
            [self setShowCalloutBubble:YES];
            
            // when the same annotation is selected, the region does not change, so regionDidChanged
            // doesn't get called
            if(sameFlat == location){
                [self calloutBubbleIn];
            } else {
                sameFlat = location;
            }
        }   
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if([annotation isKindOfClass:[Flat class]]) {
        
        static NSString *identifier = @"Flat";
        
        MKPinAnnotationView *annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
             
        annotationView.enabled = YES;   
        
        // NO, because our own bubble is coming in
        annotationView.canShowCallout = NO;
        annotationView.animatesDrop = YES;
        
        // differentiates between single and multi annotation view
        Flat *location = (Flat *) annotation;
        UIImageView *imageView;
        if([[location flatsAtAnnotation] count] > 0 ) {
            imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"annotation_multi.png"]] autorelease];
            imageView.center = CGPointMake(19, 24.5);
            [annotationView addSubview:imageView];
            [annotationView addSubview:[self setLbNumberOfFlatsAtFlat:location]];
        }
        else {
            imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"annotation_single.png"]] autorelease];
            imageView.center = CGPointMake(19, 24.5);
            [annotationView addSubview:imageView];
        }
        return annotationView;
    }
     
    return nil;
}

- (UILabel *)setLbNumberOfFlatsAtFlat:(Flat *)_flat {
    UILabel *lbNumOfFlats = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 51, 40)];
    lbNumOfFlats.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [lbNumOfFlats setText:[[NSString alloc] initWithFormat:@"%d", [[_flat flatsAtAnnotation] count] +1]];
    [lbNumOfFlats setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    
    return lbNumOfFlats;
}

- (void)setAnnotationImageAtAnnotation:(Flat *)_flat {
    MKAnnotationView *annotationView = [mapView viewForAnnotation:_flat];
    
    // deleting all existing views (labels, images) 
    UIView *v;
    for (int i=0; i<[[annotationView subviews] count]; i++){
        v = [[annotationView subviews] objectAtIndex:0];
        [v removeFromSuperview];
        v = nil;
    }
    UIImageView *imageView;
    
    if([[_flat flatsAtAnnotation] count] > 0 ) {
        imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"annotation_multi.png"]] autorelease];
        imageView.center = CGPointMake(19, 24.5);
        [annotationView addSubview:imageView];
        [annotationView addSubview:[self setLbNumberOfFlatsAtFlat:_flat]];
    }
    else {
        imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"annotation_single.png"]] autorelease];
        imageView.center = CGPointMake(19, 24.5);
        [annotationView addSubview:imageView];
    }
}

// action for the compass button
- (IBAction)refreshLocation {
    [self calloutBubbleOut];
    AppDelegate *delegate = [(AppDelegate *)[UIApplication sharedApplication] delegate];
    [delegate startLocationUpdate];
    
}

- (void)calloutBubbleIn {
    // that the flats are clickable through the imageview
    [mapView addSubview:calloutBubble];
    
    // show the image of the stretchable calloutBubble
    [calloutBubbleImg setHidden:NO];
    
    // checks hiding the right annotation
    if(isOutInCall){
        [selViewForHouseImageInOut setHidden:YES];   
    } else {
        [selViewForHouseImage setHidden:YES];
    }
	
    // animation
    [UIView beginAnimations:@"inAnimation" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];

	CGRect b = calloutBubbleImg.bounds;
	b.size.height = 172;
	b.size.width = 225;
	calloutBubbleImg.bounds =  b;
    
    CGPoint pos = calloutBubbleImg.center;
	pos.y = 115.0f;
	calloutBubbleImg.center = pos;
    
    [UIView commitAnimations]; 
    
    [self setIsCalloutBubbleIn:YES];    
    [mapView deselectAnnotation:selectedImmoScoutFlat animated:NO];    

    [mapView setZoomEnabled:NO];
}

- (IBAction)calloutBubbleOut {
    
    // hiding the text and stuff
    [scrollView setHidden:YES];
    [lbPageNumber setHidden:YES];
//    [btShowFlatsWebView setHidden:YES];
    
    // animation
    [UIView beginAnimations:@"outAnimation" context:NULL];	
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	CGRect b = calloutBubbleImg.bounds;
	b.size.height = 51;
	b.size.width = 40;
	calloutBubbleImg.bounds =  b;
    
    CGPoint pos = calloutBubbleImg.center;
	pos.y = 175.5f;
	calloutBubbleImg.center = pos;
    
    [UIView commitAnimations]; 
    [self setIsCalloutBubbleIn:NO];

    [mapView setZoomEnabled:YES];
}

- (void)animationDidStop:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    if([animationID isEqualToString:@"inAnimation"]){
        [scrollView setHidden:NO]; 
        [self initScrollView];
    } else if([animationID isEqualToString:@"outAnimation"]) {
        // calloutBubble gets removed, because it was added at calloutBubbleIn
        [calloutBubble removeFromSuperview];
        
        [calloutBubbleImg setHidden:YES];
        [self setShowCalloutBubble:NO];
        
        // sets the scrollview page to the first
        [scrollView setContentOffset:CGPointMake(0, 0)];
        
        // checks wether it was called due the calloutBubble was inside the view
        if(isOutInCall){
            [selViewForHouseImageInOut setHidden:NO];
            
            CLLocationCoordinate2D zoomLocation = selectedImmoScoutFlat.coordinate;
            MKCoordinateRegion viewRegion = MKCoordinateRegionMake(zoomLocation, mapView.region.span);
            MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
            [mapView setRegion:adjustedRegion animated:YES];   

            // calloutBubbleIn gets called at regionDidChanged, when bool showCalloutBubble is true
            [self setShowCalloutBubble:YES];
            [self setIsOutInCall:NO];
        } else {
            [selViewForHouseImage setHidden:NO];
        }
    }
}

- (IBAction)showFlatsWebView {
    // if pageControl is at a page > 0, then the selected flat is one of the flats in flatsAtAnnotation
    if(pageControl.currentPage > 0) {
        Flat *tempFlat = [[selectedImmoScoutFlat flatsAtAnnotation] objectAtIndex:self.pageControl.currentPage-1];
        [self setSelectedExposeId:[tempFlat exposeId]];
        exposeWebViewController = [[WebViewController alloc]init];
        [exposeWebViewController setSelectedImmoscoutFlat:tempFlat];
        [self.view addSubview:exposeWebViewController.view];
    }
    else {
        [self setSelectedExposeId:[selectedImmoScoutFlat exposeId]];
        exposeWebViewController = [[WebViewController alloc]init];
        [exposeWebViewController setSelectedImmoscoutFlat:[self selectedImmoScoutFlat]];
        [self.view addSubview:exposeWebViewController.view];
    }
}

// method for clustering
- (void)filterAnnotations:(NSArray *)_flatsToFilter {
    float latDelta = mapView.region.span.latitudeDelta/iphoneScaleFactorLatitude;
    float longDelta = mapView.region.span.longitudeDelta/iphoneScaleFactorLongitude;
    
    NSMutableArray *flatsToShow=[[NSMutableArray alloc] initWithCapacity:0];

    // resetting the flatsAtAnnotation array
    for (Flat *tempFlat in _flatsToFilter) {
        [[tempFlat flatsAtAnnotation] removeAllObjects];
    }
    
    for (Flat *actFlat in _flatsToFilter) {
        CLLocationDegrees latitude = [actFlat coordinate].latitude;
        CLLocationDegrees longitude = [actFlat coordinate].longitude;
        
        bool found = FALSE;
        
        for (Flat *tempFlat in flatsToShow) {
            // checks whether the actFlat is nearby to a flat, which is/should be shown
            // on the map
            if(fabs([tempFlat coordinate].latitude-latitude) < latDelta &&
               fabs([tempFlat coordinate].longitude-longitude) <longDelta ) {
 
                // if is found, remove the actFlat from view
                [mapView removeAnnotation:actFlat];
                found = TRUE;
                
                // add actFlat to the annotation of tempFlat
                [[tempFlat flatsAtAnnotation] addObject:actFlat];
                
                // change image of annotation, because now it contains more flats than before
                [self setAnnotationImageAtAnnotation:tempFlat];
                
                // break, because you can only add to one another flat
                break;
            }
        }   
        // if no flat got found nearby, add actFlat to list of all flats at the view and show it
        if(!found) {
            [flatsToShow addObject:actFlat];
            [self setAnnotationImageAtAnnotation:actFlat];
            [mapView addAnnotation:actFlat];
        }
    }
    [flatsToShow release];
}

- (void)mapView:(MKMapView *)mpView regionDidChangeAnimated:(BOOL)animated {

    // checks whether the calloutBubble is allowed to come in
    if (showCalloutBubble) {
        [self calloutBubbleIn];
    }
    
    if (zoomLevel != mpView.region.span.longitudeDelta) {
        [self filterAnnotations: [[ImmopolyManager instance] immoScoutFlats]];
        zoomLevel = mpView.region.span.longitudeDelta;
    }
}

- (void)initScrollView {
    
    // deleting all existing views (labels, images) 
    UIView *v;
    for (int i=0; i<numOfScrollViewSubviews; i++){
        v = [[scrollView subviews] objectAtIndex:0];
        [v removeFromSuperview];
        v = nil;
    }
    // + 1 because of the selected flat, which holds the other flats
    numOfScrollViewSubviews = [[selectedImmoScoutFlat flatsAtAnnotation] count]+1;
    pageControl.numberOfPages = numOfScrollViewSubviews;

    for (int i=0; i<numOfScrollViewSubviews; i++) {
        UIView *subview;
        
        if(i == 0) {
            subview = [self createCalloutBubbleContentFromFlat:selectedImmoScoutFlat atPosition:i];    
        }
        else {
            Flat *tempFlat = [[selectedImmoScoutFlat flatsAtAnnotation] objectAtIndex:i-1];
            subview = [self createCalloutBubbleContentFromFlat:tempFlat atPosition:i];    
        }
        
        [scrollView addSubview:subview];
        [subview release];
    }
    
    // setting the whole size of the scrollView
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.numOfScrollViewSubviews, self.scrollView.frame.size.height);
    
    // showing the not scrollview content of calloutBubble
//    [[self view] bringSubviewToFront:btShowFlatsWebView];    
    if (numOfScrollViewSubviews > 1) { 
        // don't show label, if it is a single flat annotation
        [lbPageNumber setHidden:NO];
        NSString *pageNum = [NSString stringWithFormat:@"1/%d", numOfScrollViewSubviews];
        [lbPageNumber setText:pageNum];
    }
    
}

- (UIView *)createCalloutBubbleContentFromFlat:(Flat *)_flat atPosition:(int)_pos {
    
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * _pos;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    
    UIView *subview = [[UIView alloc] initWithFrame:frame];
    subview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    //labels
    UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(10, -20, 193, 70)];
    [lbName setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)]];
    [lbName setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [lbName setNumberOfLines:2];
    [lbName setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [lbName setText:[_flat name]];
    [subview addSubview:lbName];
    
    UILabel *lbRooms = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, 100, 35)];
    [lbRooms setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)]];
    NSString *rooms = [NSString stringWithFormat:@"Zimmer: %d",[_flat numberOfRooms]];
    [lbRooms setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [lbRooms setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [lbRooms setText:rooms];
    [subview addSubview:lbRooms];
    
    UILabel *lbSpace = [[UILabel alloc] initWithFrame:CGRectMake(90, 55, 200, 35)];
    NSString *space = [NSString stringWithFormat:@"Fläche: %.2f qm",[_flat livingSpace]];
    [lbSpace setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)]];
    [lbSpace setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [lbSpace setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [lbSpace setText:space];
    [subview addSubview:lbSpace];
    
    UILabel *lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(90, 80, 200, 35)];
    NSString *price = [NSString stringWithFormat:@"Preis: %.2f €",[_flat price]];
    [lbPrice setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)]];
    [lbPrice setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [lbPrice setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [lbPrice setText:price];
    [subview addSubview:lbPrice];
    
    // image
    AsynchronousImageView *imgView = [[AsynchronousImageView alloc] initWithFrame:CGRectMake(10, 40, 60, 60)];
    if([_flat image] == nil) {
        [imgView loadImageFromURLString:[_flat pictureUrl] forFlat:_flat];
    } else {
        [imgView setImage:[_flat image]];
    }
    
    // button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(showFlatsWebView) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(10, 40, 60, 60);
    [subview addSubview:button];

    [subview addSubview:imgView];
     
    [lbName release];
    [lbRooms release];
    [lbSpace release];
    [lbPrice release];
    [imgView release];
    
    return subview;
}

// update the pagecontrol when more than 50% of the previous/next page is visible
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;

    NSString *pageNum = [NSString stringWithFormat:@"%d/%d", page+1, numOfScrollViewSubviews];
    [lbPageNumber setText:pageNum];
}

@end