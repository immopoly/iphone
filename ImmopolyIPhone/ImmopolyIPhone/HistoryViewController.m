//
//  HistoryViewController.m
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 09.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HistoryViewController.h"
#import "ImmopolyManager.h"
#import "HistoryEntry.h"
#import "ImmopolyHistory.h"

@implementation HistoryViewController

@synthesize tvCell, table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"History", @"Fourth");
        self.tabBarItem.image = [UIImage imageNamed:@"tab_history"];
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
    // TODO: check if user is already logged in
    if([[ImmopolyManager instance] loginSuccessful]){
        
    } 
    else {
        NSLog(@"ERROR: user has to be logged in.");
    }
    

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self table]reloadData];
    
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
    int numRows = [[[[ImmopolyManager instance] user] history] count]; 
    if(numRows > 0){
        return numRows;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected row %d",[indexPath row]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // fetching the selected history entry
    HistoryEntry *historyEntry;
    if ([[[[ImmopolyManager instance] user] history] count] > 0) {
        historyEntry = [[[[ImmopolyManager instance] user] history] objectAtIndex: indexPath.row];
    } 
    else {
        NSLog(@"user history object is empty!");
    }
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryCell" owner:self options:nil];
    UITableViewCell *cell;
    cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    
    // recycling cells
    if(cell==nil){
        cell = (UITableViewCell *)[nib objectAtIndex:0];
    }
    
    UILabel *lbTime = (UILabel *)[cell viewWithTag:1];
    UILabel *lbText = (UILabel *)[cell viewWithTag:2];
    
    NSString *time = [NSString stringWithFormat:@"%d",[historyEntry time]];
    UIColor *color = [UIColor blackColor];
    
    switch ([historyEntry type]) {
        case TYPE_EXPOSE_SOLD:
            color = [UIColor greenColor];
            break;
        case TYPE_EXPOSE_MONOPOLY_POSITIVE:
            color = [UIColor greenColor];
            break;
        case TYPE_DAILY_PROVISION:
            color = [UIColor greenColor];
            break;
        case TYPE_EXPOSE_MONOPOLY_NEGATIVE:
            color = [UIColor redColor]; 
            break;
        case TYPE_DAILY_RENT:
            color = [UIColor redColor];
            break;
        default:
            break;
    }
    
    lbTime.textColor = color;
    lbText.textColor = color;
     
    [lbTime setText: time]; 
    [lbText setText: [historyEntry histText]]; 
    return cell;
}


@end
