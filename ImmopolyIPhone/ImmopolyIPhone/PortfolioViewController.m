//
//  PortfolioViewController.m
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 29.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PortfolioViewController.h"
#import "ImmopolyManager.h"
#import "Flat.h"
#import "UserLoginTask.h"
#import "PortfolioTask.h"
#import "PortfolioCell.h"

@implementation PortfolioViewController

@synthesize tvCell;
@synthesize table;
@synthesize segmentedControl;
@synthesize portfolioMapView;
@synthesize loginCheck;
@synthesize calloutBubble;
@synthesize isOutInCall;
@synthesize isCalloutBubbleIn;
@synthesize showCalloutBubble;
@synthesize selectedExposeId;
@synthesize selectedImmoScoutFlat;
@synthesize lbFlatDescription;
@synthesize lbFlatName;
@synthesize lbFlatPrice;
@synthesize lbLivingSpace;
@synthesize asyncImageView;
@synthesize adressLabel;
@synthesize lbNumberOfRooms;
@synthesize exposeWebViewController;
@synthesize btRecenterMap;
@synthesize isBtHidden;
@synthesize topBar;
@synthesize iphoneScaleFactorLatitude;
@synthesize iphoneScaleFactorLongitude;
@synthesize scrollView;
@synthesize numOfScrollViewSubviews;
@synthesize pageControl;
@synthesize lbPageNumber;
@synthesize imgShadowTop;
@synthesize imgShadowBottom;
@synthesize sameFlat;
@synthesize regionSpan;
@synthesize loading;
@synthesize portfolioHasChanged;

static NSString *ANNO_IMG_SINGLE = @"Haus_neu_hdpi.png";
static NSString *ANNO_IMG_MULTI = @"Haus_cluster_hpdi.png";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil { 
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Portfolio", @"Second");
        [[self tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_icon_portfolio"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_icon_portfolio"]];
        self.loginCheck = [[[LoginCheck alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    [segmentedControl release];
    [loginCheck release];
    [exposeWebViewController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {  
    [table reloadData];    
    [btRecenterMap setHidden:isBtHidden];
    
    // filter annotations if a flat was added or removed from the portfolio
    if(portfolioHasChanged) {
        if(isCalloutBubbleIn) {
            [self calloutBubbleOut];    
        }
        [portfolioMapView removeAnnotations:portfolioMapView.annotations];
        [self recenterMap];
        
        [self setPortfolioHasChanged:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setShowCalloutBubble:NO];
    
    // that only the background is transparent and not the whole view
    calloutBubble.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [[self table] setHidden: YES];
    [super initSpinner];
    [super.spinner startAnimating];
    [self setIsBtHidden:YES];
    
    [self.table setBackgroundColor:[UIColor clearColor]];
    [self.table setSeparatorColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0]];
    
    // calculation for clustering
    CGFloat scrWidth = CGRectGetWidth(self.view.bounds);
    CGFloat scrHeight = CGRectGetHeight(self.view.bounds);    
    iphoneScaleFactorLatitude = (float) scrWidth/ANNO_WIDTH;
    iphoneScaleFactorLongitude = (float) scrHeight/ANNO_HEIGHT;
    [self setNumOfScrollViewSubviews:0];
    
    //[self performActionAfterLoginCheck];
    
    // setting the text of the helperView
    [super initHelperViewWithMode:INFO_PORTFOLIO];
    
    UITapGestureRecognizer *singleFingerDTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBubbleTap)];
    singleFingerDTap.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:singleFingerDTap];
    [singleFingerDTap release];
    
    [self setPortfolioHasChanged:NO];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.tvCell = nil;
    self.table = nil;
    self.adressLabel = nil;
    self.lbFlatName = nil;
    self.lbFlatDescription = nil;
    self.lbFlatPrice = nil;
    self.lbNumberOfRooms = nil;
    self.lbLivingSpace = nil;
    self.topBar = nil;
    self.btRecenterMap = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    // closing calloutBubble when the user returns from another tab
    // [self calloutBubbleOut];
    
    loginCheck.delegate = self;
    [loginCheck checkUserLogin];
    
    [super viewDidAppear:animated];
}

#pragma mark - UserDataDelegate

- (void)performActionAfterLoginCheck {
    [table reloadData];
   
    [self stopSpinnerAnimation];
    [[self table] setHidden: NO];
    
    // do in background and only filter if no annotations are on the map
    if([[self.portfolioMapView valueForKeyPath:@"annotations.coordinate"] count] == 0) {
        [self filterAnnotations: [[[ImmopolyManager instance] user] portfolio]];   
        [self recenterMap];
    }
    
    if ([[[ImmopolyManager instance]user]portfolio] == nil || [[[[ImmopolyManager instance]user]portfolio]count]<=0) {
        [super helperViewIn];
    }
}

- (void)stopSpinner
{
    [self stopSpinnerAnimation];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// UITableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[[ImmopolyManager instance] user] portfolio] count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 104;
}

            
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self setSelectedImmoScoutFlat:[[[[ImmopolyManager instance]user]portfolio]objectAtIndex:[indexPath row]]];
    
    if (exposeWebViewController) {
        [exposeWebViewController setSelectedImmoscoutFlat:[self selectedImmoScoutFlat]];
        [exposeWebViewController reloadData];
    }else{
        exposeWebViewController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:[NSBundle mainBundle]];
        exposeWebViewController.delegate = self;
    }
    [exposeWebViewController setSelectedImmoscoutFlat:[self selectedImmoScoutFlat]];
    exposeWebViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:exposeWebViewController animated:YES];
}
                
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Flat *actFlat = [[[[ImmopolyManager instance] user] portfolio] objectAtIndex: indexPath.row];

    PortfolioCell *cell = (PortfolioCell *)[tableView dequeueReusableCellWithIdentifier:@"PortfolioCell"];
    
    // recycling cells
    if(cell==nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PortfolioCell" owner:self options:nil];
        cell = (PortfolioCell *)[nib objectAtIndex:0];
    }
    [cell setFlat:actFlat];

    return cell;
}

- (IBAction)showList {
    [self showListWithAnimation:YES];
}

- (void)showListWithAnimation:(BOOL)_animated {
    [self calloutBubbleOut];
    
    [topBar setImage:[UIImage imageNamed:@"topbar_portfolio_list.png"]];
    
    CGPoint posMap = portfolioMapView.center;
    CGPoint posTable = table.center;
    CGPoint posImgShadowTop = imgShadowTop.center;
    CGPoint posImgShadowBottom = imgShadowBottom.center;
    
    [btRecenterMap setHidden:YES];
    [self setIsBtHidden:YES];
    
    if(_animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        posMap.x = 480.0f;
        posTable.x = 164.0f;
        posImgShadowTop.x = 160.0f;
        posImgShadowBottom.x = 160.0f;
        portfolioMapView.center = posMap;
        table.center = posTable;
        imgShadowTop.center = posImgShadowTop;
        imgShadowBottom.center = posImgShadowBottom; 
        [UIView commitAnimations];     
    } else {
        posMap.x = 480.0f;
        posTable.x = 164.0f;
        posImgShadowTop.x = 160.0f;
        posImgShadowBottom.x = 160.0f;
        portfolioMapView.center = posMap;
        table.center = posTable;
        imgShadowTop.center = posImgShadowTop;
        imgShadowBottom.center = posImgShadowBottom; 
    }
}

- (IBAction)showMap {
    [self showMapWithAnimation:YES];
}

- (void)showMapWithAnimation:(BOOL)_animated {
    
    [topBar setImage:[UIImage imageNamed:@"topbar_portfolio_map.png"]];
    [self setIsBtHidden:NO];
    
    CGPoint posMap = portfolioMapView.center;
    CGPoint posTable = table.center;
    CGPoint posImgShadowTop = imgShadowTop.center;
    CGPoint posImgShadowBottom = imgShadowBottom.center;
    
    if(_animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        posMap.x = 160.0f;
        posTable.x = -160.0f;
        posImgShadowTop.x = -160.0f;
        posImgShadowBottom.x = -160.0f;
        portfolioMapView.center = posMap;
        table.center = posTable;
        imgShadowTop.center = posImgShadowTop;
        imgShadowBottom.center = posImgShadowBottom;    
        [UIView commitAnimations];
        
        [self recenterMap];
    } else {
        posMap.x = 160.0f;
        posTable.x = -160.0f;
        posImgShadowTop.x = -160.0f;
        posImgShadowBottom.x = -160.0f;
        portfolioMapView.center = posMap;
        table.center = posTable;
        imgShadowTop.center = posImgShadowTop;
        imgShadowBottom.center = posImgShadowBottom;  
    }
}

/* ========== MapView methods ========== */

- (void)mapView:(MKMapView *)mpView regionDidChangeAnimated:(BOOL)animated {
    
    // checks whether the calloutBubble is allowed to come in
    if (showCalloutBubble) {
        [self calloutBubbleIn];
    }
    
    if (zoomLevel != mpView.region.span.longitudeDelta) {
        [self filterAnnotations: [[[ImmopolyManager instance] user] portfolio]];
        zoomLevel = mpView.region.span.longitudeDelta;
    }
    // save the span for detecting, when the region did change, but the same annotation was selected
    regionSpan.latitudeDelta = mpView.region.span.latitudeDelta;
}

// method for clustering
- (void)filterAnnotations:(NSArray *)_flatsToFilter {
    float latDelta = portfolioMapView.region.span.latitudeDelta/iphoneScaleFactorLatitude;
    float longDelta = portfolioMapView.region.span.longitudeDelta/iphoneScaleFactorLongitude;
    
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
                [portfolioMapView removeAnnotation:actFlat];
                found = TRUE;
                
                // add actFlat to the annotation of tempFlat
                [[tempFlat flatsAtAnnotation] addObject:actFlat];
                
                // annotation bild der tempflat ändern, weil sie jetzt mehrere flats beinhaltet
                [self setAnnotationImageAtAnnotation:tempFlat];
                
                // break, because you can only add to one another flat
                break;
            }
        }   
        // if no flat got found nearby, add actFlat to list of all flats at the view and show it
        if(!found) {
            [flatsToShow addObject:actFlat];
            [self setAnnotationImageAtAnnotation:actFlat];
            [portfolioMapView addAnnotation:actFlat];
        }
    }
    [flatsToShow release];
}

- (void)mapView:(MKMapView *)mpView didSelectAnnotationView:(MKAnnotationView *)view{
    
    // TODO: wenn die selbe annotation gewählt wird, ohne die region zu verändern,
    //       wird calloutBubbleIn nicht aufgerufen
    
    if(isCalloutBubbleIn){
        [self setIsOutInCall:YES];
        [self calloutBubbleOut];
        
        if([view.annotation isKindOfClass:[Flat class]]) {
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
            MKCoordinateRegion viewRegion = MKCoordinateRegionMake(zoomLocation, portfolioMapView.region.span);
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if([annotation isKindOfClass:[Flat class]]) {
        
        static NSString *identifier = @"Flat";
        
        MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
        
        annotationView.enabled = YES;   
        
        // NO, because our own bubble is coming in
        annotationView.canShowCallout = NO;
        
        // differentiates between single and multi annotation view
        Flat *location = (Flat *) annotation;
        if([[location flatsAtAnnotation] count] > 0 ) {
            annotationView.image = [UIImage imageNamed:ANNO_IMG_MULTI];
            [annotationView addSubview:[self setLbNumberOfFlatsAtFlat:location]];
        }
        else {
            annotationView.image = [UIImage imageNamed:ANNO_IMG_SINGLE];
        }
        return annotationView;
    }
    
    return nil;
}

- (UILabel *)setLbNumberOfFlatsAtFlat:(Flat *)_flat {
    UILabel *lbNumOfFlats = [[[UILabel alloc] initWithFrame:CGRectMake(-5, 0, 72, 58)] autorelease];
    lbNumOfFlats.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [lbNumOfFlats setText:[NSString stringWithFormat:@"%d", [[_flat flatsAtAnnotation] count] +1]];
    [lbNumOfFlats setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]];
    lbNumOfFlats.font = [UIFont boldSystemFontOfSize:15];
    [lbNumOfFlats setTextAlignment:UITextAlignmentCenter];
    
    return lbNumOfFlats;
}

- (void)setAnnotationImageAtAnnotation:(Flat *)_flat {
    MKAnnotationView *annotationView = [portfolioMapView viewForAnnotation:_flat];
    
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
    else {
        annotationView.image = [UIImage imageNamed:ANNO_IMG_SINGLE];
    }
}

- (void)calloutBubbleIn {
    // that the flats are clickable through the imageview
    [portfolioMapView addSubview:calloutBubble];
	
    // animation
    [UIView beginAnimations:@"inAnimation" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    CGPoint pos = calloutBubble.center;
	pos.y = 185.0f;
	calloutBubble.center = pos;
    
    [UIView commitAnimations]; 
    
    [self setIsCalloutBubbleIn:YES];    
    [portfolioMapView deselectAnnotation:selectedImmoScoutFlat animated:NO];    
    
    [portfolioMapView setZoomEnabled:NO];
}

- (void)calloutBubbleOut {
    
    // animation
    [UIView beginAnimations:@"outAnimation" context:NULL];	
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
    CGPoint pos = calloutBubble.center;
	pos.y = -185.0f;
	calloutBubble.center = pos;
    
    [UIView commitAnimations]; 
    [self setIsCalloutBubbleIn:NO];
    
    [portfolioMapView setZoomEnabled:YES];
}

- (void)animationDidStop:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    if([animationID isEqualToString:@"inAnimation"]){
        [scrollView setHidden:NO]; 
        [self initScrollView];
    } else if([animationID isEqualToString:@"outAnimation"]) {
        // calloutBubble gets removed, because it was added at calloutBubbleIn
        [calloutBubble removeFromSuperview];
        
        [self setShowCalloutBubble:NO];
        
        // sets the scrollview page to the first
        [scrollView setContentOffset:CGPointMake(0, 0)];
        
        // checks wether it was called due the calloutBubble was inside the view
        if(isOutInCall){
            CLLocationCoordinate2D zoomLocation = selectedImmoScoutFlat.coordinate;
            MKCoordinateRegion viewRegion = MKCoordinateRegionMake(zoomLocation, portfolioMapView.region.span);
            MKCoordinateRegion adjustedRegion = [portfolioMapView regionThatFits:viewRegion];                
            [portfolioMapView setRegion:adjustedRegion animated:YES];   
            
            // calloutBubbleIn gets called at regionDidChanged, when bool showCalloutBubble is true
            [self setShowCalloutBubble:YES];
            [self setIsOutInCall:NO];
        }
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
    
    UIView *subview = [[[UIView alloc] initWithFrame:frame] autorelease];
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
    AsynchronousImageView *imgView = [[AsynchronousImageView alloc] initWithFrame:CGRectMake(10, 40, 60, 60)];
    if([_flat image] == nil) {
        [imgView loadImageFromURLString:[_flat pictureUrl] forFlat:_flat];
    } else {
        [imgView setImage:[_flat image]];
    }
    
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

- (void)recenterMap {
    
    NSMutableArray *annotations = [[[ImmopolyManager instance] user] portfolio];
    // setting the number of flats, because maybe the user removes one of them at webview
    
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
        

        [self.portfolioMapView setRegion:region animated:YES]; 
        
    } else {
        // zoom to germany? ^^
    }
}

- (IBAction)showAllFlats {
    [self calloutBubbleOut];
    [self recenterMap];
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
        exposeWebViewController.delegate = self;
        [exposeWebViewController setSelectedImmoscoutFlat:tempFlat];
    }
    else {
        [self setSelectedExposeId:[selectedImmoScoutFlat exposeId]];
        exposeWebViewController = [[WebViewController alloc]init];
        exposeWebViewController.delegate = self;
        [exposeWebViewController setSelectedImmoscoutFlat:[self selectedImmoScoutFlat]];
    }
    exposeWebViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:exposeWebViewController animated:YES];
}

#pragma mark - NotifyViewDelegate

-(void)notifyMyDelegateView{
    loading = NO;
    [super.spinner stopAnimating];
    [super.spinner setHidden: YES];
    
    [[self table]reloadData];
    [self filterAnnotations: [[[ImmopolyManager instance] user] portfolio]];
    [self recenterMap];
    
    //ToDo: actualise
}

- (void)closeMyDelegateView {}

- (void)notifyMyDelegateViewWithUser:(ImmopolyUser *)user {}

- (void)showSelectedFlatOnMap:(Flat *)flat{
    [self showMapWithAnimation:NO];
    [self calloutBubbleIn];
    
    // moving the view to the center where the selected flat is placed
    CLLocationCoordinate2D zoomLocation = flat.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.01*METERS_PER_MILE, 0.01*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [portfolioMapView regionThatFits:viewRegion];                
    [portfolioMapView setRegion:adjustedRegion animated:NO];   
    
    // see didSelectAnnotation if conditions
    sameFlat = flat;
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


@end
