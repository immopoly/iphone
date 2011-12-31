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
#import "HistoryTask.h"

@implementation HistoryViewController

@synthesize tvCell;
@synthesize table;
@synthesize loginCheck;
@synthesize spinner;
@synthesize loading;
@synthesize flagForReload;
@synthesize loadingHistoryEntriesLimit;
@synthesize loadingHistoryEntriesStart;
@synthesize reloadDataSpinner;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"History", @"Fourth");
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_history"];
        self.loginCheck = [[LoginCheck alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self table] setHidden: YES];
    [spinner startAnimating];
    [self.table setBackgroundColor:[UIColor clearColor]];
    [self.table setSeparatorColor:[[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.0]];
    
    loadingHistoryEntriesStart = 10;
    loadingHistoryEntriesLimit = 10;
    
    [reloadDataSpinner stopAnimating];
    
    //[self performActionAfterLoginCheck];
    
    // setting the text of the helperView
    [super initHelperView];
    [super setHelperViewTitle:@"Hilfe zur Historyansicht"];
}

- (void)viewDidAppear:(BOOL)animated {
    loginCheck.delegate = self;
    [loginCheck checkUserLogin];
    
    [super viewDidAppear:animated];
    [[self table]reloadData];
    
    
}

- (void)stopSpinnerAnimation {
    [spinner stopAnimating];
    [spinner setHidden: YES];
}

- (void)performActionAfterLoginCheck {
    [table reloadData];
    [self stopSpinnerAnimation];
    [[self table] setHidden: NO];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.tvCell = nil;
    self.table = nil;
    self.spinner = nil;
    self.reloadDataSpinner = nil;
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
        
        long timeInterval = [historyEntry time]/1000; //1321922162430
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        [dateFormatter release];      
        
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
                [lblImage setImage:[UIImage imageNamed:@"icon_info"]];
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
    
    
    if ([indexPath row]>[[[[ImmopolyManager instance] user] history] count]-3) {
        if (loading) {
            flagForReload = YES;
        }else{
            flagForReload = NO;
            loading = YES;
            
            HistoryTask *task = [[[HistoryTask alloc] init] autorelease];
            task.delegate = self;
            [task loadHistoryEintriesFrom:loadingHistoryEntriesStart To:(loadingHistoryEntriesStart+loadingHistoryEntriesLimit)];
            [reloadDataSpinner startAnimating];
        }
    }
    
    if(flagForReload){
        if(!loading){
            flagForReload = NO;
            loading = YES;
            
            HistoryTask *task = [[[HistoryTask alloc] init] autorelease];
            task.delegate = self;
            [task loadHistoryEintriesFrom:loadingHistoryEntriesStart To:(loadingHistoryEntriesStart+loadingHistoryEntriesLimit)];
            [reloadDataSpinner startAnimating];
        }
      }
    
    return cell;
}

- (void)hasMoreData:(bool)result {
    if (result) {
        loading = false;
        loadingHistoryEntriesStart+=10;
    }
    
    [self.table reloadData];
    [reloadDataSpinner stopAnimating];
}

- (void)dealloc {
    [tvCell release];
    [table release];
    [loginCheck release];
    [spinner release];
    [reloadDataSpinner release];
    [super dealloc];
}

-(void) loginWithResult:(BOOL)_result {
    
}

@end
