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

@synthesize tvCell, table, loginCheck, spinner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"History", @"Fourth");
        self.tabBarItem.image = [UIImage imageNamed:@"tab_history"];
        self.loginCheck = [[LoginCheck alloc] init];
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
    [[self table] setHidden: YES];
    [spinner startAnimating];
    [self.table setBackgroundColor:[UIColor clearColor]];
    [self.table setSeparatorColor:[[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.0]];
}

- (void)viewDidAppear:(BOOL)animated {
    loginCheck.delegate = self;
    [loginCheck checkUserLogin];
    [super viewDidAppear:animated];
    [[self table]reloadData];
}

-(void) stopSpinnerAnimation {
    [spinner stopAnimating];
    [spinner setHidden: YES];
}

-(void) displayUserData {
    [table reloadData];
    [self stopSpinnerAnimation];
    [[self table] setHidden: NO];
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
    /*int numRows = [[[[ImmopolyManager instance] user] history] count]; 
    if(numRows > 0){
        return numRows;
    }
    else {
        return 1;
    }
     */
    return [[[[ImmopolyManager instance] user] history] count]; 
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 89;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected row %d",[indexPath row]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryCell" owner:self options:nil];
    UITableViewCell *cell;
    cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    
    // recycling cells
    if(cell==nil){
        cell = (UITableViewCell *)[nib objectAtIndex:0];
    }
    
    UILabel *lbTime = (UILabel *)[cell viewWithTag:1];
    UILabel *lbText = (UILabel *)[cell viewWithTag:2];
    UIImageView *lblImage = (UIImageView *)[cell viewWithTag:3];
    
    // fetching the selected history entry
    HistoryEntry *historyEntry;
    if ([[[[ImmopolyManager instance] user] history] count] > 0) {
        historyEntry = [[[[ImmopolyManager instance] user] history] objectAtIndex: indexPath.row];
        
        // Convert string to date object
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        [dateFormatter setDateFormat:@"'am' dd.MM.yyyy 'um' HH:mm 'Uhr'"];
        
        double timeInterval = [historyEntry time]/1000; //1321922162430
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        NSLog(@"formattedDateString: %@", formattedDateString);
        
        UIColor *color = [UIColor blackColor];
        
        switch ([historyEntry type]) {
            case TYPE_EXPOSE_SOLD:
                [lblImage setImage:[UIImage imageNamed:@"icon_plus"]];
                break;
            case TYPE_EXPOSE_MONOPOLY_POSITIVE:
                [lblImage setImage:[UIImage imageNamed:@"icon_plus"]];
                break;
            case TYPE_DAILY_PROVISION:
                [lblImage setImage:[UIImage imageNamed:@"icon_plus"]];
                break;
            case TYPE_EXPOSE_MONOPOLY_NEGATIVE:
                [lblImage setImage:[UIImage imageNamed:@"icon_minus"]]; 
                break;
            case TYPE_DAILY_RENT:
                [lblImage setImage:[UIImage imageNamed:@"icon_minus"]];
                break;
            default:
                //TODO: NEUTRALES ICON
                break;
        }
        
        lbTime.textColor = color;
        lbText.textColor = color;
        
//        NSString *time = [NSString stringWithFormat:@"%d", [historyEntry time]];
//        [lbTime setText: time]; 
        [lbTime setText: formattedDateString]; 
        [lbText setText: [historyEntry histText]];
    } 
    else {
        NSLog(@"user history object is empty!");
        [lbTime setHidden: YES];
        [lbText setHidden: YES];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void) dealloc {
    [tvCell release];
    [table release];
    [loginCheck release];
    [spinner release];
    [super dealloc];
}


@end
