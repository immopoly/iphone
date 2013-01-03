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
#import "UIDevice+Resolutions.h"


@interface PortfolioViewController() {
    IBOutlet UITableViewCell *tvCell;
    IBOutlet UITableView *table;
    
    IBOutlet UIImageView *topBar;
    IBOutlet UIButton *btRecenterMap;
    
    IBOutlet UIImageView *imgShadowTop;
    IBOutlet UIImageView *imgShadowBottom;
    
    BOOL isRecenterButtonHidden;
    BOOL loading;
    
    LoginCheck *loginCheck;
    WebViewController *exposeWebViewController;
}

@end

@implementation PortfolioViewController

@synthesize hasPortfolioChanged;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil { 
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Portfolio", @"Second");
        [[self tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_icon_portfolio"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_icon_portfolio"]];
        loginCheck = [[LoginCheck alloc] init];
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
    [table reloadData];    
    [btRecenterMap setHidden:isRecenterButtonHidden];
    
    // filter annotations if a flat was added or removed from the portfolio
    if(hasPortfolioChanged) {
        if(isCalloutBubbleIn) {
            [self calloutBubbleOut];    
        }
        [mapView removeAnnotations:mapView.annotations];
        [self recenterMap];        
        hasPortfolioChanged = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 42; // top navigation view
    frame.size.height -= 20; // status bar
    frame.size.height -= 49; // tabbar
    self.view.frame = frame;
    
    if ([[UIDevice currentDevice] resolution] == UIDeviceResolution_iPhoneRetina4) {
        [self.backgroundImageView setImage:[UIImage imageNamed:@"history_background_568h@2x.png"]];
    } else {
        [self.backgroundImageView setImage:[UIImage imageNamed:@"history_background.png"]];
    }
    frame.origin.y = 42;
    [self.backgroundImageView setFrame:frame];
    
    frame.size.height += 42;
    [table setFrame:frame];

    // bottom shadow
    CGRect shadowFrame = imgShadowBottom.frame;
    shadowFrame.origin.y = table.frame.size.height - 10;
    [imgShadowBottom setFrame:shadowFrame];
    
    CGRect buttonFrame = btRecenterMap.frame;
    buttonFrame.origin.y = self.view.frame.size.height - 20;
    [btRecenterMap setFrame:buttonFrame];
    
    [super initHelperViewWithMode:INFO_PORTFOLIO];
    [table setHidden: YES];
    [table setBackgroundColor:[UIColor clearColor]];
    [table setSeparatorColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0]];
    isRecenterButtonHidden = YES;
    hasPortfolioChanged = NO;
    
    [self.view bringSubviewToFront:btRecenterMap];
    
    CGPoint posMap = mapView.center;
    posMap.x = 480.0f;
    mapView.center = posMap;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    tvCell = nil;
    table = nil;
    topBar = nil;
    btRecenterMap = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    loginCheck.delegate = self;
    [loginCheck checkUserLogin];
    
    [super viewDidAppear:animated];
}

#pragma mark - UserDataDelegate

- (void)performActionAfterLoginCheck {
    [table reloadData];
   
    [self stopSpinnerAnimation];
    [table setHidden: NO];
    
    // do in background and only filter if no annotations are on the map
    [mapView removeAnnotations:mapView.annotations];
    if([[mapView valueForKeyPath:@"annotations.coordinate"] count] == 0) {
        [super filterAnnotations: [[[ImmopolyManager instance] user] portfolio]];
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
    
    selectedImmoScoutFlat = [[[[ImmopolyManager instance]user]portfolio]objectAtIndex:[indexPath row]];
    
    if (exposeWebViewController) {
        [exposeWebViewController setSelectedImmoscoutFlat:selectedImmoScoutFlat];
        [exposeWebViewController reloadData];
    }else{
        exposeWebViewController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:[NSBundle mainBundle]];
        exposeWebViewController.delegate = self;
    }
    [exposeWebViewController setSelectedImmoscoutFlat:selectedImmoScoutFlat];
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
    
    CGPoint posMap = mapView.center;
    CGPoint posTable = table.center;
    CGPoint posImgShadowTop = imgShadowTop.center;
    CGPoint posImgShadowBottom = imgShadowBottom.center;
    
    [btRecenterMap setHidden:YES];
    isRecenterButtonHidden = YES;
    
    if(_animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        posMap.x = 480.0f;
        posTable.x = 164.0f;
        posImgShadowTop.x = 160.0f;
        posImgShadowBottom.x = 160.0f;
        mapView.center = posMap;
        table.center = posTable;
        imgShadowTop.center = posImgShadowTop;
        imgShadowBottom.center = posImgShadowBottom; 
        [UIView commitAnimations];     
    } else {
        posMap.x = 480.0f;
        posTable.x = 164.0f;
        posImgShadowTop.x = 160.0f;
        posImgShadowBottom.x = 160.0f;
        mapView.center = posMap;
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
    [btRecenterMap setHidden:NO];
    isRecenterButtonHidden = NO;
    
    CGPoint posMap = mapView.center;
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
        mapView.center = posMap;
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
        mapView.center = posMap;
        table.center = posTable;
        imgShadowTop.center = posImgShadowTop;
        imgShadowBottom.center = posImgShadowBottom;  
    }
}

/* ========== MapView methods ========== */


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
        

        [mapView setRegion:region animated:YES];
        
    } else {
        // zoom to germany? ^^
    }
}

- (IBAction)showAllFlats {
    [self calloutBubbleOut];
    [self recenterMap];
}

- (void)showSelectedFlatOnMap:(Flat *)flat{
    [self showMapWithAnimation:NO];
    [super calloutBubbleIn];
    
    // moving the view to the center where the selected flat is placed
    CLLocationCoordinate2D zoomLocation = flat.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.01*METERS_PER_MILE, 0.01*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:NO];
    
    // see didSelectAnnotation if conditions
    sameFlat = flat;
}

#pragma mark - NotifyViewDelegate

-(void)notifyMyDelegateView{
    loading = NO;
    [super.spinner stopAnimating];
    [super.spinner setHidden: YES];
    
    [table reloadData];
    [super filterAnnotations: [[[ImmopolyManager instance] user] portfolio]];
    [self recenterMap];
    
    //ToDo: actualise
}

- (void)closeMyDelegateView {}

- (void)notifyMyDelegateViewWithUser:(ImmopolyUser *)user {}

@end
