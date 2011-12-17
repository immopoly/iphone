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
@synthesize selectedImmoScoutFlat;
@synthesize isCalloutBubbleIn;
@synthesize isOutInCall;
@synthesize selViewForHouseImage;
@synthesize asyncImageView;
@synthesize iphoneScaleFactorLatitude;
@synthesize iphoneScaleFactorLongitude;
@synthesize scrollView;
@synthesize numOfScrollViewSubviews;
@synthesize pageControl;


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
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_map"];
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

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.calloutBubble = nil;
    self.asyncImageView = nil;
    self.scrollView = nil;
    self.pageControl = nil;
    
}

- (void)viewDidAppear:(BOOL)animated {
    CGPoint pos = calloutBubble.center;
	pos.y = -320.0f;
	calloutBubble.center = pos;
	
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
        [self setSelectedImmoScoutFlat:location]; 
        
        // moving the view to the center where the selected flat is placed
        CLLocationCoordinate2D zoomLocation = location.coordinate;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMake(zoomLocation, mapView.region.span);
        MKCoordinateRegion adjustedRegion = [mpView regionThatFits:viewRegion];                
        [mpView setRegion:adjustedRegion animated:YES];   
        
        if (!isOutInCall) {
            [self calloutBubbleIn];
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
        
        // checks that annotation is not the current position    
        Flat *location = (Flat *) annotation;
        UIImageView *imageView;
        if([[location flatsAtAnnotation] count] > 0 ) {
            imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"annotation_multi.png"]] autorelease];
            [annotationView addSubview:imageView];
            [annotationView addSubview:[self setLbNumberOfFlatsAtFlat:location]];
        }
        else {
            imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"annotation_single.png"]] autorelease];
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
    
    UIImageView *imageView = [[annotationView subviews] objectAtIndex:0];
    
    if([[_flat flatsAtAnnotation] count] > 0 ) {
        imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"annotation_multi.png"]] autorelease];
        [annotationView addSubview:imageView];
        [[[annotationView subviews] objectAtIndex:1] removeFromSuperview];
        [annotationView addSubview:[self setLbNumberOfFlatsAtFlat:_flat]];
    }
    else {
        imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"annotation_single.png"]] autorelease];
        if([[annotationView subviews] count] > 1){
            [[[annotationView subviews] objectAtIndex:1] removeFromSuperview];    
        }
        [annotationView addSubview:imageView];
    }
}

// action for the compass button
- (IBAction)refreshLocation {
    AppDelegate *delegate = [(AppDelegate *)[UIApplication sharedApplication] delegate];
    [delegate startLocationUpdate];
    
}

- (void)calloutBubbleIn {
    // that the flats are clickable through the imageview
    [mapView addSubview:calloutBubble];
    
    [self initScrollView];
     
    // Animation
    [UIView beginAnimations:@"inAnimation" context:NULL];	
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];    
	[UIView setAnimationDuration:0.4];
	
	CGPoint pos = calloutBubble.center;
	pos.y = 164.0f;
	calloutBubble.center = pos;
	
    [UIView commitAnimations]; 

    // showing or hiding the pageControl
    if (numOfScrollViewSubviews == 1) {
        [pageControl setHidden:YES];
    }
    else {
        [pageControl setHidden:NO];
    }
    
    [self setIsCalloutBubbleIn:true];    
    [mapView deselectAnnotation:selectedImmoScoutFlat animated:NO];    
    
    
    //selViewForHouseImage.image = [UIImage imageNamed:@"annotation_multi_small.png"];

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
    
    /*
    if([[selectedImmoScoutFlat flatsAtAnnotation] count] > 0) {
        //selViewForHouseImage.image = [UIImage imageNamed:@"annotation_multi_small.png"];
        [self setAnnotationImageAtAnnotation:selectedImmoScoutFlat];
    } else {
        //selViewForHouseImage.image = [UIImage imageNamed:@"annotation_single_small.png"];
        [self setAnnotationImageAtAnnotation:selectedImmoScoutFlat];
    }
    */
    [mapView setZoomEnabled:YES];
}

- (void)animationDidStop:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    if([animationID isEqualToString:@"inAnimation"]){
        NSLog(@"animation in");
    } else if([animationID isEqualToString:@"outAnimation"]) {
        NSLog(@"animation out");
        [calloutBubble removeFromSuperview];
        
        // sets the scrollview page to the first
        [scrollView setContentOffset:CGPointMake(0, 0)];
        
        // checks wether it was called due the calloutBubble was inside the view
        if(isOutInCall){
            [self calloutBubbleIn];
            [self setIsOutInCall:NO];
        }
    }
}

- (void)showFlatsWebView {
    // if pageControl is at a page > 0, then the selected flat is one of the flats in flatsAtAnnotation
    if(self.pageControl.currentPage > 0) {
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
    
    for (int i=0; i<[_flatsToFilter count]; i++) {
        Flat *actFlat = [_flatsToFilter objectAtIndex:i];
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
                
                // annotation bild der tempflat ändern, weil sie jetzt mehrere flats beinhaltet
                [self setAnnotationImageAtAnnotation:tempFlat];
                
                // break, weil eine in der nähe befindliche flat reicht
                break;
            }
        }   
        // wenn keine flat in der nähe gefunden wurde, adde diese flat zur Liste aller flats,
        // die gezeigt werden und zeige die Annotation
        if(!found) {
            [flatsToShow addObject:actFlat];
            [self setAnnotationImageAtAnnotation:actFlat];
            [mapView addAnnotation:actFlat];
        }
    }
    [flatsToShow release];

}

- (void)mapView:(MKMapView *)mpView regionDidChangeAnimated:(BOOL)animated {
    if (zoomLevel != mpView.region.span.longitudeDelta || animated) {
        [self filterAnnotations: [[ImmopolyManager instance] immoScoutFlats]];
        zoomLevel = mpView.region.span.longitudeDelta;
    }
}

- (void)initScrollView {
    
    // deleting all existing views (labels, images) 
    UIView *v;
    for (NSInteger i=0; i<numOfScrollViewSubviews; i++){
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
    NSString *space = [NSString stringWithFormat:@"Fläche: %f qm",[_flat livingSpace]];
    space = [space substringToIndex:[space length]-7];
    [lbSpace setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)]];
    [lbSpace setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [lbSpace setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [lbSpace setText:space];
    [subview addSubview:lbSpace];
    
    UILabel *lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(90, 80, 200, 35)];
    NSString *price = [NSString stringWithFormat:@"Preis: %f €",[_flat price]];
    price = [price substringToIndex:[price length]-6];
    [lbPrice setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)]];
    [lbPrice setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [lbPrice setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [lbPrice setText:price];
    [subview addSubview:lbPrice];
    
    UILabel *lbPageNum = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, 200, 35)];
    NSString *pageNum = [NSString stringWithFormat:@"%d/%d", _pos+1, numOfScrollViewSubviews];
    [lbPageNum setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)]];
    [lbPageNum setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [lbPageNum setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [lbPageNum setText:pageNum];
    [subview addSubview:lbPageNum];
    
    // image
    AsynchronousImageView *img = [[AsynchronousImageView alloc] initWithFrame:CGRectMake(10, 40, 60, 60)];
    [img loadImageFromURLString:[_flat pictureUrl]];
    [subview addSubview:img];

    // button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(showFlatsWebView) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@">" forState:UIControlStateNormal];
    button.frame = CGRectMake(180, 120, 25, 25);
    [subview addSubview:button];
    
    [lbName release];
    [lbRooms release];
    [img release];
    
    return subview;
}

// update the pagecontrol when more than 50% of the previous/next page is visible
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}
@end
