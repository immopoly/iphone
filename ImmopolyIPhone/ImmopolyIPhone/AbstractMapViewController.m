//
//  AbstractMapViewController.m
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 12.12.12.
//
//

#import "AbstractMapViewController.h"
#import "ImmopolyManager.h"
#import "Flat.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "ImmopolyMapViewController.h"

static NSString *ANNO_IMG_SINGLE = @"Haus_neu_hdpi.png";
static NSString *ANNO_IMG_MULTI = @"Haus_cluster_hpdi.png";
static NSString *ANNO_IMG_OWN = @"Haus_meins_hdpi.png";

@interface AbstractMapViewController () {
    UILabel *lbPageNumber;
    UIView *calloutBubble;
    AsynchronousImageView *asyncImageView;
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    
    WebViewController *exposeWebViewController;
    
    bool isOutInCall;
    bool showCalloutBubble;
    int selectedExposeId;
    UITapGestureRecognizer* tapRec;
    
    // variables vor clustering
    float iphoneScaleFactorLatitude;
    float iphoneScaleFactorLongitude;
    CLLocationDegrees zoomLevel;
    int numOfScrollViewSubviews;
    MKCoordinateSpan regionSpan;
}

@end

@implementation AbstractMapViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMapView];
    [self initCalloutBubble];
    [self initScrollView];
    [super initSpinner];
    
    showCalloutBubble = NO;
    
    // that only the background is transparent and not the whole view
    calloutBubble.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    // calculation for clustering
    CGFloat scrWidth = CGRectGetWidth(self.view.bounds);
    CGFloat scrHeight = CGRectGetHeight(self.view.bounds);
    iphoneScaleFactorLatitude = (float) scrWidth/ANNO_WIDTH;
    iphoneScaleFactorLongitude = (float) scrHeight/ANNO_HEIGHT;
    numOfScrollViewSubviews = 0;
    
    UITapGestureRecognizer *singleFingerDTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBubbleTap)];
    singleFingerDTap.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:singleFingerDTap];
    
    tapRec = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleGesture:)];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [mapView setZoomEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initMapView {
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 42, 320, 370)];
    mapView.delegate = self;
    [self.view addSubview:mapView];
}

-(void)initCalloutBubble {
    CGRect  viewRect = CGRectMake(54, -172, 225, 172);
    calloutBubble = [[UIView alloc] initWithFrame:viewRect];
    [self.view addSubview:calloutBubble];
    
    UIImageView *imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calloutBubble.png"]]; 
    [calloutBubble addSubview:imageView];
    
    lbPageNumber = [[UILabel alloc] initWithFrame:CGRectMake(14, 122, 42, 21)];
    [lbPageNumber setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)]];
    [lbPageNumber setTextColor:[UIColor colorWithRed:40.0/255.0 green:77.0/255.0 blue:125.0/255.0 alpha:1]];
    [lbPageNumber setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    
    [calloutBubble addSubview:lbPageNumber];
}

-(void)initScrollView {
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(4, 0, 216, 147)];
    [scrollView setPagingEnabled:YES];
    scrollView.showsHorizontalScrollIndicator = NO;
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    scrollView.delegate = self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    [self calloutBubbleOut];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)displayFlatsOnMap {
    [self stopSpinnerAnimation];
    
    // removing all existing annotations
    for (id<MKAnnotation> annotation in mapView.annotations) {
        if([annotation isKindOfClass:[Flat class]]){
            [mapView removeAnnotation:annotation];
        }
    }
    
    if([[[ImmopolyManager instance] immoScoutFlats] count] > 0) {
        // gets called that the filter is running and the flats are shown at the view
        if([self isMemberOfClass:[ImmopolyMapViewController class]]) {
            [self filterAnnotations: [[ImmopolyManager instance] immoScoutFlats]];
        } else {
            [self filterAnnotations: [[[ImmopolyManager instance] user] portfolio]];
        }
    } else {
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:alertNoFlatsAvailabe delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
}

- (void)recenterMap {
    NSMutableArray *annotations = [[ImmopolyManager instance] immoScoutFlats];
    
    if([annotations count] > 0) {
        CLLocationCoordinate2D maxCoord = {-90.0f, -180.0f};
        CLLocationCoordinate2D minCoord = {90.0f, 180.0f};
        
        for(Flat *flat in annotations) {
            
            CLLocationCoordinate2D coord = [flat coordinate];
            
            if(coord.longitude > maxCoord.longitude) {
                maxCoord.longitude = coord.longitude;
            }
            
            if(coord.latitude > maxCoord.latitude) {
                maxCoord.latitude = coord.latitude;
            }
            
            if(coord.longitude < minCoord.longitude) {
                minCoord.longitude = coord.longitude;
            }
            
            if(coord.latitude < minCoord.latitude) {
                minCoord.latitude = coord.latitude;
            }
        }
        
        MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
        region.center.longitude = (minCoord.longitude + maxCoord.longitude) / 2.0;
        region.center.latitude = (minCoord.latitude + maxCoord.latitude) / 2.0;
        region.span.longitudeDelta = maxCoord.longitude - minCoord.longitude;
        region.span.latitudeDelta = maxCoord.latitude - minCoord.latitude;
        
        
        [mapView setRegion:region animated:YES];
    }
}

- (void)mapView:(MKMapView *)mpView didSelectAnnotationView:(MKAnnotationView *)view{
    
    if(isCalloutBubbleIn){
        isOutInCall = YES;
        [self calloutBubbleOut];
        
        if([view.annotation isKindOfClass:[Flat class]]) {
            // that the right annotation gets shown, whenn an outIn call is happening
            Flat *location = (Flat *) view.annotation;
            selectedImmoScoutFlat = location;
            sameFlat = location;
        }
    }
    else {
        if([view.annotation isKindOfClass:[Flat class]]) {
            Flat *location = (Flat *) view.annotation;
            selectedImmoScoutFlat = location;
            
            [mapView setCenterCoordinate:location.coordinate animated:YES];
            
            // calloutBubbleIn gets called at regionDidChanged, when bool showCalloutBubble is true
            showCalloutBubble = YES;
            
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
        
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
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
    [lbNumOfFlats setText:[NSString stringWithFormat:@"%d", [[_flat flatsAtAnnotation] count] +1]];
    [lbNumOfFlats setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    lbNumOfFlats.font = [UIFont boldSystemFontOfSize:15];
    [lbNumOfFlats setTextAlignment:UITextAlignmentCenter];
    
    return lbNumOfFlats;
}

- (void)setAnnotationImageAtAnnotation:(Flat *)_flat {
    MKAnnotationView *annotationView = [mapView viewForAnnotation:_flat];
    
    // deleting all existing views (labels, images)
    int subviewsCount = [[annotationView subviews] count];
    if (subviewsCount > 0) {
        UIView *v;
        for (int i=0; i<subviewsCount; i++){
            v = [[annotationView subviews] objectAtIndex:0];
            [v removeFromSuperview];
            v = nil;
        }
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

- (void)calloutBubbleIn {
    // that the flats are clickable through the imageview
    //[mapView addSubview:calloutBubble];
    
    [mapView addGestureRecognizer:tapRec];
    
    // animation
    [UIView beginAnimations:@"inAnimation" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    CGPoint pos = calloutBubble.center;
	pos.y = 160.0f;
	calloutBubble.center = pos;
    
    [UIView commitAnimations];
    
    isCalloutBubbleIn = YES;
    [mapView deselectAnnotation:selectedImmoScoutFlat animated:NO];
    
    [mapView setZoomEnabled:NO];
}

- (void)calloutBubbleOut {
    
    if (tapRec != nil) {
        [mapView removeGestureRecognizer:tapRec];
    }
    
    // animation
    [UIView beginAnimations:@"outAnimation" context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    CGPoint pos = calloutBubble.center;
	pos.y = -86.0f;
	calloutBubble.center = pos;
    
    [UIView commitAnimations];
    isCalloutBubbleIn = NO;
    
    [mapView setZoomEnabled:YES];
}

- (void)animationDidStop:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    if([animationID isEqualToString:@"inAnimation"]){
        [self prepareScrollView];
    } else if([animationID isEqualToString:@"outAnimation"]) {
        
        // sets the scrollview page to the first
        [scrollView setContentOffset:CGPointMake(0, 0)];
        [self resetScrollView];
        
        // checks wether it was called due the calloutBubble was inside the view
        if(isOutInCall){
            CLLocationCoordinate2D zoomLocation = selectedImmoScoutFlat.coordinate;
            MKCoordinateRegion viewRegion = MKCoordinateRegionMake(zoomLocation, mapView.region.span);
            MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
            [mapView setRegion:adjustedRegion animated:YES];
            
            // calloutBubbleIn gets called at regionDidChanged, when bool showCalloutBubble is true
            showCalloutBubble = YES;
            isOutInCall = NO;
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
}

- (void)mapView:(MKMapView *)mpView regionDidChangeAnimated:(BOOL)animated {
    
    // checks whether the calloutBubble is allowed to come in
    if (showCalloutBubble) {
        [self calloutBubbleIn];
    }
    
    if (zoomLevel != mpView.region.span.longitudeDelta) {
        if([self isMemberOfClass:[ImmopolyMapViewController class]]) {
            [self filterAnnotations: [[ImmopolyManager instance] immoScoutFlats]];
        } else {
            [self filterAnnotations: [[[ImmopolyManager instance] user] portfolio]];
        }
        zoomLevel = mpView.region.span.longitudeDelta;
    }
    // save the span for detecting, when the region did change, but the same annotation was selected
    regionSpan.latitudeDelta = mpView.region.span.latitudeDelta;
}

- (void)prepareScrollView {
    
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
    }
    
    // setting the whole size of the scrollView
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * numOfScrollViewSubviews, scrollView.frame.size.height);
    
    // showing the not scrollview content of calloutBubble
    if (numOfScrollViewSubviews > 1) {
        // don't show label, if it is a single flat annotation
        [lbPageNumber setHidden:NO];
        NSString *pageNum = [NSString stringWithFormat:@"1/%d", numOfScrollViewSubviews];
        [lbPageNumber setText:pageNum];
    } else {
        [lbPageNumber setHidden:YES];
    }
    [calloutBubble addSubview:scrollView];
}

- (void)resetScrollView {
    int subviewCount = [[scrollView subviews] count];
    if(subviewCount > 0) {
        UIView *v;
        for (int i=0; i<subviewCount; i++){
            v = [[scrollView subviews] objectAtIndex:0];
            [v removeFromSuperview];
            v = nil;
        }
    }
    [lbPageNumber setText:@""];
}

- (UIView *)createCalloutBubbleContentFromFlat:(Flat *)_flat atPosition:(int)_pos {
    
    CGRect frame;
    frame.origin.x = scrollView.frame.size.width * _pos;
    frame.origin.y = 0;
    frame.size = scrollView.frame.size;
    
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
    
    return subview;
}

// update the pagecontrol when more than 50% of the previous/next page is visible
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    NSString *pageNum = [NSString stringWithFormat:@"%d/%d", page+1, numOfScrollViewSubviews];
    [lbPageNumber setText:pageNum];
}

- (void)handleBubbleTap{
    // if pageControl is at a page > 0, then the selected flat is one of the flats in flatsAtAnnotation
    if(pageControl.currentPage > 0) {
        Flat *tempFlat = [[selectedImmoScoutFlat flatsAtAnnotation] objectAtIndex:pageControl.currentPage-1];
        selectedExposeId = [tempFlat exposeId];
        exposeWebViewController = [[WebViewController alloc]init];
        [exposeWebViewController setSelectedImmoscoutFlat:tempFlat];
    }
    else {
        selectedExposeId = [selectedImmoScoutFlat exposeId];
        exposeWebViewController = [[WebViewController alloc]init];
        [exposeWebViewController setSelectedImmoscoutFlat:selectedImmoScoutFlat];
    }
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
    [self calloutBubbleOut];
    showCalloutBubble = NO;
}

@end
