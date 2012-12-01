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
#import "Constants.h"

static NSString *ANNO_IMG_SINGLE = @"Haus_neu_hdpi.png";
static NSString *ANNO_IMG_MULTI = @"Haus_cluster_hpdi.png";
static NSString *ANNO_IMG_OWN = @"Haus_meins_hdpi.png";

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
@synthesize asyncImageView;
@synthesize iphoneScaleFactorLatitude;
@synthesize iphoneScaleFactorLongitude;
@synthesize scrollView;
@synthesize numOfScrollViewSubviews;
@synthesize pageControl;
@synthesize sameFlat;
@synthesize regionSpan;

- (void)showFlatSpinner{
    [[super spinner]setHidden:NO];
    [[super spinner]startAnimating];
}
    

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
    
    if (![self alreadyUsed]) {
       //Show first start text
        
        [self initHelperViewWithMode:INFO_IMMOPOLY];
        [self initButton];
        [self helperViewIn];        
        
       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alreadyUsed"];
        
        
    }else{
        [self initHelperViewWithMode:INFO_MAP];
    }
}

- (void)helperViewIn {
    if ([self alreadyUsed]) {
        [self initHelperViewWithMode:INFO_MAP];
    }
    [super helperViewIn];
}

- (BOOL)alreadyUsed{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"alreadyUsed"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super initSpinner];
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
    
    // setting the text of the helperView
    [super initHelperViewWithMode:INFO_MAP];
    
    UITapGestureRecognizer *singleFingerDTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBubbleTap)];
    singleFingerDTap.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:singleFingerDTap];
    [singleFingerDTap release];
    
    UITapGestureRecognizer* tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(closeBubble)];
    [mapView addGestureRecognizer:tapRec];
    [tapRec release];
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
    [super stopSpinnerAnimation];
    
    // removing all existing annotations
    for (id<MKAnnotation> annotation in mapView.annotations) {
        if([annotation isKindOfClass:[Flat class]]){    
            [mapView removeAnnotation:annotation];
        }
    }     
    
    if([[[ImmopolyManager instance] immoScoutFlats] count] > 0) {
        // gets called that the filter is running and the flats are shown at the view
        [self filterAnnotations: [[ImmopolyManager instance] immoScoutFlats]];
    } else {
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:alertNoFlatsAvailabe delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
    }
}

- (void)mapView:(MKMapView *)mpView didSelectAnnotationView:(MKAnnotationView *)view{

    if(isCalloutBubbleIn){
        [self setIsOutInCall:YES];
        [self calloutBubbleOut];
        
        if([view.annotation isKindOfClass:[Flat class]]) {
            // that the right annotation gets shown, whenn an outIn call is happening
            Flat *location = (Flat *) view.annotation;
            [self setSelectedImmoScoutFlat:location]; 
            sameFlat = location;
        }
    }
    else {
        if([view.annotation isKindOfClass:[Flat class]]) {
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
                if(regionSpan.latitudeDelta == mpView.region.span.latitudeDelta)
                    [self calloutBubbleIn];
            } else {
                sameFlat = location;
            }
        }   
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if([annotation isKindOfClass:[Flat class]]) {
        
        static NSString *identifier = @"Flat";
        
        MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
        
        annotationView.enabled = YES;   
        
        // NO, because our own bubble is coming in
        annotationView.canShowCallout = NO;
        //annotationView.animatesDrop = YES;
        
        // differentiates between single and multi annotation view
        Flat *location = (Flat *) annotation;        
        if([[location flatsAtAnnotation] count] > 0 ) {
            annotationView.image = [UIImage imageNamed:ANNO_IMG_MULTI];
            [annotationView addSubview:[self setLbNumberOfFlatsAtFlat:location]];
        }
        else if ([self checkOfOwnFlat:location]) {
            annotationView.image = [UIImage imageNamed:ANNO_IMG_OWN];
        } else {
            annotationView.image = [UIImage imageNamed:ANNO_IMG_SINGLE];
        } 
        return annotationView;
    }
     
    return nil;
}

- (UILabel *)setLbNumberOfFlatsAtFlat:(Flat *)_flat {
    UILabel *lbNumOfFlats = [[UILabel alloc] initWithFrame:CGRectMake(-5, 0, 72, 58)];
    lbNumOfFlats.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [lbNumOfFlats setText:[[NSString alloc] initWithFormat:@"%d", [[_flat flatsAtAnnotation] count] +1]];
    [lbNumOfFlats setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    lbNumOfFlats.font = [UIFont boldSystemFontOfSize:15];
    [lbNumOfFlats setTextAlignment:UITextAlignmentCenter];
    
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

    if([[_flat flatsAtAnnotation] count] > 0 ) {
        annotationView.image = [UIImage imageNamed:ANNO_IMG_MULTI];
        [annotationView addSubview:[self setLbNumberOfFlatsAtFlat:_flat]];
    }
    else if ([self checkOfOwnFlat:_flat]) {
        annotationView.image = [UIImage imageNamed:ANNO_IMG_OWN];
    } else {

        annotationView.image = [UIImage imageNamed:ANNO_IMG_SINGLE];
    }
}

- (BOOL)checkOfOwnFlat:(Flat *)_flat {    
    if ([[[[ImmopolyManager instance] user] portfolio] count] != 0) {
        for (Flat *tempFlat in [[[ImmopolyManager instance] user] portfolio]) {
            if ([tempFlat exposeId] == [_flat exposeId]) {
                return YES;
            }
        }
    }
    return NO;
}

// action for the compass button
- (IBAction)refreshLocation {
    [self calloutBubbleOut];
    AppDelegate *delegate = [(AppDelegate *)[UIApplication sharedApplication] delegate];
    [delegate startLocationUpdate];
    
    [delegate setIsLocationUpdated:NO];
    [[[ImmopolyManager instance] immoScoutFlats] removeAllObjects];
}

- (void)calloutBubbleIn {
    // that the flats are clickable through the imageview
    //[mapView addSubview:calloutBubble];
    
    // animation
    [UIView beginAnimations:@"inAnimation" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    CGPoint pos = calloutBubble.center;
	pos.y = 160.0f;
	calloutBubble.center = pos;
    
    [UIView commitAnimations]; 
    
    [self setIsCalloutBubbleIn:YES];    
    [mapView deselectAnnotation:selectedImmoScoutFlat animated:NO];    

    [mapView setZoomEnabled:NO];
}

- (void)calloutBubbleOut {
    
    // animation
    [UIView beginAnimations:@"outAnimation" context:NULL];	
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	 
    CGPoint pos = calloutBubble.center;
	pos.y = -86.0f;
	calloutBubble.center = pos;
    
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
        //[calloutBubble removeFromSuperview];
        
        [self setShowCalloutBubble:NO];
        
        // sets the scrollview page to the first
        [scrollView setContentOffset:CGPointMake(0, 0)];
        
        // checks wether it was called due the calloutBubble was inside the view
        if(isOutInCall){
            CLLocationCoordinate2D zoomLocation = selectedImmoScoutFlat.coordinate;
            MKCoordinateRegion viewRegion = MKCoordinateRegionMake(zoomLocation, mapView.region.span);
            MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
            [mapView setRegion:adjustedRegion animated:YES];   

            // calloutBubbleIn gets called at regionDidChanged, when bool showCalloutBubble is true
            [self setShowCalloutBubble:YES];
            [self setIsOutInCall:NO];
        }
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
    // save the span for detecting, when the region did change, but the same annotation was selected
    regionSpan.latitudeDelta = mpView.region.span.latitudeDelta;
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
    if (numOfScrollViewSubviews > 1) { 
        // don't show label, if it is a single flat annotation
        [lbPageNumber setHidden:NO];
        NSString *pageNum = [NSString stringWithFormat:@"1/%d", numOfScrollViewSubviews];
        [lbPageNumber setText:pageNum];
    } else {
        [lbPageNumber setHidden:YES];
    }
    
}

- (UIView *)createCalloutBubbleContentFromFlat:(Flat *)_flat atPosition:(int)_pos {
    
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * _pos;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    
    UIView *subview = [[UIView alloc] initWithFrame:frame];
    subview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    UIColor *textColor = [UIColor colorWithRed:63.0/255.0 green:100.0/255.0 blue:148.0/255.0 alpha:1];
    UIColor *backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    //labels
    UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(10, -15, 193, 70)];
    [lbName setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)]];
    [lbName setBackgroundColor:backgroundColor];
    [lbName setNumberOfLines:2];
    [lbName setTextColor:[UIColor colorWithRed:40.0/255.0 green:77.0/255.0 blue:125.0/255.0 alpha:1]];
    [lbName setText:[_flat name]];
    [subview addSubview:lbName];
    
    UILabel *lbRooms = [[UILabel alloc] initWithFrame:CGRectMake(90, 35, 100, 35)];
    [lbRooms setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)]];
    NSString *rooms = [NSString stringWithFormat:@"Zimmer: %d",[_flat numberOfRooms]];
    [lbRooms setBackgroundColor:backgroundColor];
    [lbRooms setTextColor:textColor];
    [lbRooms setText:rooms];
    [subview addSubview:lbRooms];
    
    UILabel *lbSpace = [[UILabel alloc] initWithFrame:CGRectMake(90, 60, 200, 35)];
    NSString *space = [NSString stringWithFormat:@"Fläche: %.2f m²",[_flat livingSpace]];
    [lbSpace setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)]];
    [lbSpace setBackgroundColor:backgroundColor];
    [lbSpace setTextColor:textColor];
    [lbSpace setText:space];
    [subview addSubview:lbSpace];
    
    UILabel *lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(90, 85, 200, 35)];
    NSString *price = [NSString stringWithFormat:@"Preis: %.2f €",[_flat price]];
    [lbPrice setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)]];
    [lbPrice setBackgroundColor:backgroundColor];
    [lbPrice setTextColor:textColor];
    [lbPrice setText:price];
    [subview addSubview:lbPrice];
    
    // image
    AsynchronousImageView *imgView = [[AsynchronousImageView alloc] initWithFrame:CGRectMake(10, 45, 60, 60)];
    if([_flat image] == nil) {
        [imgView loadImageFromURLString:[_flat pictureUrl] forFlat:_flat];
    } else {
        [imgView setImage:[_flat image]];
    }
    [subview addSubview:imgView];
    
    // banner image
    if ([self checkOfOwnFlat:_flat]) {
        UIImageView *bannerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(133, 1, 83, 80)];
        bannerImgView.image = [UIImage imageNamed:@"banner_for_own_flat.png"];
        [subview addSubview:bannerImgView];
        [bannerImgView release];
    } 
    
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

// method for a big invisible button to close the calloutBubble
- (IBAction)closeBubble {
    if(!isOutInCall){
        [self calloutBubbleOut];    
    }
}

- (void)handleBubbleTap{
    // if pageControl is at a page > 0, then the selected flat is one of the flats in flatsAtAnnotation
    if(pageControl.currentPage > 0) {
        Flat *tempFlat = [[selectedImmoScoutFlat flatsAtAnnotation] objectAtIndex:self.pageControl.currentPage-1];
        [self setSelectedExposeId:[tempFlat exposeId]];
        exposeWebViewController = [[WebViewController alloc]init];
        [exposeWebViewController setSelectedImmoscoutFlat:tempFlat];
    }
    else {
        [self setSelectedExposeId:[selectedImmoScoutFlat exposeId]];
        exposeWebViewController = [[WebViewController alloc]init];
        [exposeWebViewController setSelectedImmoscoutFlat:[self selectedImmoScoutFlat]];
    }
    //[self.view addSubview:exposeWebViewController.view];
    exposeWebViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:exposeWebViewController animated:YES];
}

// delegate method for annotations dropping animation
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views { 
    MKAnnotationView *aV; 
    for (aV in views) {
        CGRect endFrame = aV.frame;
        
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - 230.0, aV.frame.size.width, aV.frame.size.height);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.35];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [aV setFrame:endFrame];
        [UIView commitAnimations];
    }
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    [self setShowCalloutBubble:NO];
    [self calloutBubbleOut];
}

@end