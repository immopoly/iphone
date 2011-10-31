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

@implementation PortfolioViewController

@synthesize tvCell, table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{ 
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    return [[[ImmopolyManager instance] ImmoScoutFlats] count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}

            
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected row %d",[indexPath row]);
}
                
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // should be the flats from portfolio
    Flat *actFlat = [[[ImmopolyManager instance] ImmoScoutFlats] objectAtIndex:indexPath.row];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PortfolioCell" owner:self options:nil];
    
    UITableViewCell *cell;
    
    cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PortfolioCell"];
    
    // recycling cells
    if(cell==nil){
        cell = (UITableViewCell *)[nib objectAtIndex:0];
    }

    UIImageView *imgView = (UIImageView *)[cell viewWithTag:1];
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    [label setText:[actFlat name]]; 
    
    return cell;
}

@end