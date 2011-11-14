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
    // Do any additional setup after loading the view from its nib.
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
            break;
        default:
            break;
    }

}

@end
