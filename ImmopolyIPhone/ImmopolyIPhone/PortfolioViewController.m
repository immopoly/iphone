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

@implementation PortfolioViewController

@synthesize tvCell, table, segmentedControl, portfolioMapView, loginCheck,calloutBubble,isOutInCall,isCalloutBubbleIn,selectedExposeId,selViewForHouseImage,selectedImmoScoutFlat,lbFlatDescription,lbFlatName,lbFlatPrice,lbLivingSpace,adressLabel,lbNumberOfRooms,exposeWebViewController, spinner, btRecenterMap, isBtHidden,topBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{ 
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Portfolio", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"tab_portfolio"];
        self.loginCheck = [[LoginCheck alloc] init];
    }
    return self;
}

- (void)dealloc {
    [segmentedControl release];
    [loginCheck release];
    [spinner release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // that only the background is transparent and not the whole view
    calloutBubble.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [[self table] setHidden: YES];
    [spinner startAnimating];
    [self setIsBtHidden:YES];
    
    [self.table setBackgroundColor:[UIColor clearColor]];
    [self.table setSeparatorColor:[[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.0]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    loginCheck.delegate = self;
    [loginCheck checkUserLogin];
    
    [super viewDidAppear:animated];
    [[self table]reloadData];
    
    CGPoint pos = calloutBubble.center;
	pos.y = -320.0f;
	calloutBubble.center = pos;
    [btRecenterMap setHidden:isBtHidden];
}

-(void) stopSpinnerAnimation {
    [spinner stopAnimating];
    [spinner setHidden: YES];
}

-(void) displayUserData {
    [table reloadData];
    
    // removing all existing annotations
    for (id<MKAnnotation> annotation in portfolioMapView.annotations) {
        // check that the my location annotion does not get removed
        if([annotation isKindOfClass:[Flat class]] && ![((Flat *)annotation).title isEqualToString:@"My Location"]){    
            [portfolioMapView removeAnnotation:annotation];
        }
    }     
    
    for(Flat *flat in [[[ImmopolyManager instance] user]portfolio]) {
        [portfolioMapView addAnnotation: flat];
    }
    
    [self recenterMap];
    
    [self stopSpinnerAnimation];
    [[self table] setHidden: NO];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// UITableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    /*
    if ([[[[ImmopolyManager instance] user] portfolio] count] > 0) {
        return [[[[ImmopolyManager instance] user] portfolio] count];
    }
    else {
        return [[[ImmopolyManager instance] immoScoutFlats] count];
    }
     */
    return [[[[ImmopolyManager instance] user] portfolio] count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

            
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self setSelectedImmoScoutFlat:[[[[ImmopolyManager instance]user]portfolio]objectAtIndex:[indexPath row]]];
    
    
    if (exposeWebViewController) {
        [exposeWebViewController setSelectedImmoscoutFlat:[self selectedImmoScoutFlat]];
        [exposeWebViewController reloadData];
        [self.view addSubview:exposeWebViewController.view];
    }else{
        exposeWebViewController = [[WebViewController alloc]init];
    }
    
    [exposeWebViewController setSelectedImmoscoutFlat:[self selectedImmoScoutFlat]];
    [self.view addSubview:exposeWebViewController.view];
    
    
}
                
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Flat *actFlat = [[[[ImmopolyManager instance] user] portfolio] objectAtIndex: indexPath.row];

    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PortfolioCell"];
    
    UILabel *lbStreet;
    UILabel *lbRooms;
    UILabel *lbSpace;
    AsynchronousImageView *asyncImageViewList;
    
    // recycling cells
    if(cell==nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PortfolioCell" owner:self options:nil];
        cell = (UITableViewCell *)[nib objectAtIndex:0];
        
    }else{
        NSLog(@"Bla");
        //STOP SPINNER
        //[asyncImageViewList reset];
    }
    
    asyncImageViewList = (AsynchronousImageView *)[cell viewWithTag:1];
    lbStreet = (UILabel *)[cell viewWithTag:2];
    lbRooms = (UILabel *)[cell viewWithTag:3];
    lbSpace = (UILabel *)[cell viewWithTag:4];
    [asyncImageViewList reset];
    
    [asyncImageViewList loadImageFromURLString:[actFlat pictureUrl]];
    
    NSString *rooms = [NSString stringWithFormat:@"Zimmer: %d",[actFlat numberOfRooms]];
    NSString *space = [NSString stringWithFormat:@"qm: %f",[actFlat livingSpace]];
    
    space = [space substringToIndex:[space length]-7];
    
    [lbStreet setText: [actFlat title]];
    [lbStreet setText: actFlat.street]; 
    [lbRooms setText: rooms]; 
    [lbSpace setText: space];
     
    return cell;
}

-(IBAction) segmentedControlIndexChanged{
    CGPoint pos = calloutBubble.center;
	pos.y = -320.0f;
	calloutBubble.center = pos;
    
    CGPoint posMap;
    CGPoint posTable;
    NSLog(@"selIndex: %d", segmentedControl.selectedSegmentIndex);
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            [btRecenterMap setHidden:YES];
            [self setIsBtHidden:YES];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.4];
            posMap = portfolioMapView.center;
            posTable = table.center;
            posMap.x = 480.0f;
            posTable.x = 160.0f;
            portfolioMapView.center = posMap;
            table.center = posTable;
            [UIView commitAnimations]; 
            break;
        case 1:
            [btRecenterMap setHidden:NO];
            [self setIsBtHidden:NO];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.4];
            posMap = portfolioMapView.center;
            posTable = table.center;
            posMap.x = 160.0f;
            posTable.x = -160.0f;
            portfolioMapView.center = posMap;
            table.center = posTable;
            [UIView commitAnimations];
            [self recenterMap];
            break;
        default:
            break;
    }

}

- (IBAction)showList{
    [topBar setImage:[UIImage imageNamed:@"topbar_portfolio_list.png"]];
    
    CGPoint pos = calloutBubble.center;
	pos.y = -320.0f;
	calloutBubble.center = pos;
    
    CGPoint posMap;
    CGPoint posTable;
    
    [btRecenterMap setHidden:YES];
    [self setIsBtHidden:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    posMap = portfolioMapView.center;
    posTable = table.center;
    posMap.x = 480.0f;
    posTable.x = 160.0f;
    portfolioMapView.center = posMap;
    table.center = posTable;
    [UIView commitAnimations]; 

}
- (IBAction)showMap{
    [topBar setImage:[UIImage imageNamed:@"topbar_portfolio_map.png"]];
    
    CGPoint pos = calloutBubble.center;
	pos.y = -320.0f;
	calloutBubble.center = pos;
    
    CGPoint posMap;
    CGPoint posTable;
    [btRecenterMap setHidden:NO];
    [self setIsBtHidden:NO];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    posMap = portfolioMapView.center;
    posTable = table.center;
    posMap.x = 160.0f;
    posTable.x = -160.0f;
    portfolioMapView.center = posMap;
    table.center = posTable;
    [UIView commitAnimations];
    [self recenterMap];

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
        
        // moving the coordinates, that it doesn't zoom to the center, but a bit under it 
        CLLocationCoordinate2D zoomLocation = location.coordinate;
        zoomLocation.latitude = zoomLocation.latitude + 0.003;
        zoomLocation.longitude = zoomLocation.longitude + 0.0006;
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.3*METERS_PER_MILE, 0.3*METERS_PER_MILE);
        MKCoordinateRegion adjustedRegion = [mpView regionThatFits:viewRegion];                
        [mpView setRegion:adjustedRegion animated:YES];   
        
        if (![location.title compare:@"My Location"] == NSOrderedSame && !isOutInCall) {
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

- (void)recenterMap {
    
    NSArray *coordinates = [self.portfolioMapView valueForKeyPath:@"annotations.coordinate"];
    
    if([coordinates count] > 0) {
        CLLocationCoordinate2D maxCoord = {-90.0f, -180.0f};
        
        CLLocationCoordinate2D minCoord = {90.0f, 180.0f};
        
        
        
        for(NSValue *value in coordinates) {
            
            CLLocationCoordinate2D coord = {0.0f, 0.0f};
            
            [value getValue:&coord];
            
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

- (void)calloutBubbleIn {
    // that the flats are clickable through the imageview
    [portfolioMapView addSubview:calloutBubble];
    
    // setting text of labels in calloutBubble
    [lbFlatName setText:[selectedImmoScoutFlat name]];
    NSString *rooms = [NSString stringWithFormat:@"Zimmer: %d",[selectedImmoScoutFlat numberOfRooms]];
    NSString *space = [NSString stringWithFormat:@"Fläche: %f qm",[selectedImmoScoutFlat livingSpace]];
    NSString *price = [NSString stringWithFormat:@"Preis: %f €",[selectedImmoScoutFlat price]];
    
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
	pos.y = 180.0f;
	calloutBubble.center = pos;
	
    [UIView commitAnimations]; 
    [self setIsCalloutBubbleIn:true];
    [portfolioMapView deselectAnnotation:selectedImmoScoutFlat animated:NO];    
    selViewForHouseImage.image = [UIImage imageNamed:@"house_green_selected.png"];
    [portfolioMapView setZoomEnabled:NO];
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
    
    selViewForHouseImage.image = [UIImage imageNamed:@"house_green.png"];
    [portfolioMapView setZoomEnabled:YES];
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
    //[exposeWebViewController setSelectedExposeId:[self selectedExposeId]];
    [exposeWebViewController setSelectedImmoscoutFlat:[self selectedImmoScoutFlat]];
    [self.view addSubview:exposeWebViewController.view];
}

- (IBAction)showAllFlats {
    [self calloutBubbleOut];
    [self recenterMap];
}


@end
