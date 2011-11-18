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

@synthesize tvCell, table, segmentedControl, portfolioMapView, loginCheck;

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
    return 96;
}

            
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected row %d",[indexPath row]);
}
                
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //flats from portfolio
    Flat *actFlat = [[[[ImmopolyManager instance] user] portfolio] objectAtIndex: indexPath.row];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PortfolioCell" owner:self options:nil];
    
    UITableViewCell *cell;
    
    cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PortfolioCell"];
    
    // recycling cells
    if(cell==nil){
        cell = (UITableViewCell *)[nib objectAtIndex:0];
    }

//    UIImageView *imgView = (UIImageView *)[cell viewWithTag:1];
    UILabel *lbStreet = (UILabel *)[cell viewWithTag:2];
    UILabel *lbRooms = (UILabel *)[cell viewWithTag:3];
    UILabel *lbSpace = (UILabel *)[cell viewWithTag:4];
    
    NSString *rooms = [NSString stringWithFormat:@"Zimmer: %d",[actFlat numberOfRooms]];
    NSString *space = [NSString stringWithFormat:@"qm: %f",[actFlat livingSpace]];
    
    [lbStreet setText: [actFlat title]];
    //[lbStreet setText: actFlat.street]; 
    //[lbRooms setText: rooms]; 
    //[lbSpace setText: space]; 
    return cell;
}

-(IBAction) segmentedControlIndexChanged{
    CGPoint posMap;
    CGPoint posTable;
    NSLog(@"selIndex: %d", segmentedControl.selectedSegmentIndex);
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
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

- (void)mapView:(MKMapView *)mpView didSelectAnnotationView:(MKAnnotationView *)view{
    //TODO: handle click
    
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
    
}

@end
