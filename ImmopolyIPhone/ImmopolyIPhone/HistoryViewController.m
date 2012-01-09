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
#import "FacebookManager.h"
#import "Constants.h"
#import "Secrets.h"


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
@synthesize lbTime;
@synthesize lbText;
@synthesize btShareBack;
@synthesize btFacebook;
@synthesize btTwitter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"History", @"Fourth");
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_history"];
        self.loginCheck = [[[LoginCheck alloc] init] autorelease];
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
    [self.table setBackgroundColor:[UIColor clearColor]];
    [self.table setSeparatorColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0]];
    
    loadingHistoryEntriesStart = 10;
    loadingHistoryEntriesLimit = 10;
    
    [reloadDataSpinner stopAnimating];
    
    //[self performActionAfterLoginCheck];
    
    // setting the text of the helperView
    [super initHelperViewWithMode:INFO_HISTORY];
    
    // set this controller to facebook delegate stuff
    [[FacebookManager getInstance] set_APP_KEY:facebookAppKey];
	[[FacebookManager getInstance] set_SECRET_KEY:facebookAppSecret];    
    [FacebookManager getInstance].delegate = self;
    
    // setting all entries to not activated
    for (HistoryEntry *entry in [[[ImmopolyManager instance] user] history]) {
        [entry setIsSharingActivated:NO];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [[self table]reloadData];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [spinner startAnimating];
    loginCheck.delegate = self;
    [loginCheck checkUserLogin];
    
    [super viewDidAppear:animated];
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
    self.lbText = nil;
    self.lbTime = nil;
    self.btShareBack = nil;
    self.btFacebook = nil;
    self.btTwitter = nil;
    self.btHelperViewIn = nil;
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
    
    HistoryEntry *histEntry = [[[[ImmopolyManager instance] user] history] objectAtIndex:[indexPath row]];
    [histEntry setIsSharingActivated:YES];
    
    // hiding the text and showing the buttons for sharing an entry
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    lbTime = (UILabel *)[selectedCell viewWithTag:1];
    lbText = (UILabel *)[selectedCell viewWithTag:2];
    btShareBack = (UIButton *)[selectedCell viewWithTag:4];
    btFacebook = (UIButton *)[selectedCell viewWithTag:5];
    btTwitter = (UIButton *)[selectedCell viewWithTag:6];
    
    [self viewFadeOut:lbTime];
    [self viewFadeOut:lbText];
    [self viewFadeIn:btShareBack];
    [self viewFadeIn:btFacebook];
    [self viewFadeIn:btTwitter];
}

-(IBAction)showCellLabels:(id)sender{
    
    UIView *senderButton = (UIView*) sender;
    NSIndexPath *indexPath = [table indexPathForCell: (UITableViewCell*)[[senderButton superview]superview]];
    
    UITableViewCell *selectedCell = [table cellForRowAtIndexPath:indexPath];
    lbTime = (UILabel *)[selectedCell viewWithTag:1];
    lbText = (UILabel *)[selectedCell viewWithTag:2];
    btShareBack = (UIButton *)[selectedCell viewWithTag:4];
    btFacebook = (UIButton *)[selectedCell viewWithTag:5];
    btTwitter = (UIButton *)[selectedCell viewWithTag:6];
    
    HistoryEntry *histEntry = [[[[ImmopolyManager instance] user] history] objectAtIndex: indexPath.row];
    [histEntry setIsSharingActivated:NO];
    

    [self viewFadeIn:lbTime];
    [self viewFadeIn:lbText];
    [self viewFadeOut:btShareBack];
    [self viewFadeOut:btFacebook];
    [self viewFadeOut:btTwitter];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryCell" owner:self options:nil];
    UITableViewCell *cell;
    cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    
    // recycling cells
    if(cell==nil){
        cell = (UITableViewCell *)[nib objectAtIndex:0];
    }
    
    lbTime = (UILabel *)[cell viewWithTag:1];
    lbText = (UILabel *)[cell viewWithTag:2];
    UIImageView *lblImage = (UIImageView *)[cell viewWithTag:3];
    btShareBack = (UIButton *)[cell viewWithTag:4];
    btFacebook = (UIButton *)[cell viewWithTag:5];
    btTwitter = (UIButton *)[cell viewWithTag:6];
    
     //adding the actions because in xib not visible yet
    [btShareBack addTarget:self action:@selector(showCellLabels:) forControlEvents:UIControlEventTouchUpInside];
    /*[btFacebook addTarget:self action:@selector(facebook) forControlEvents:UIControlEventTouchUpInside];
    [btTwitter addTarget:self action:@selector(twitter) forControlEvents:UIControlEventTouchUpInside];*/
    
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
        
        // defining which icon get choosed
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
    
        
        // showing or hiding the share stuff
        if([historyEntry isSharingActivated]) {
            [lbTime setAlpha:0.0f];
            [lbText setAlpha:0.0f];
            [btShareBack setAlpha:1.0f];
            [btFacebook setAlpha:1.0f];
            [btTwitter setAlpha:1.0f];
        } else {
            [lbTime setAlpha:1.0f];
            [lbText setAlpha:1.0f];
            [btShareBack setAlpha:0.0f];
            [btFacebook setAlpha:0.0f];
            [btTwitter setAlpha:0.0f];
        }
        
        // setting text
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
            task.refresh = NO;
            [task loadHistoryEintriesFrom:loadingHistoryEntriesStart To:(loadingHistoryEntriesStart+loadingHistoryEntriesLimit)];
            loadingHistoryEntriesStart+=10;
            [reloadDataSpinner startAnimating];
        }
      }
    
    return cell;
}

- (void)hasMoreData:(bool)result {
    if (result) {
        loading = false;
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
    [lbTime release];
    [lbText release];
    [btShareBack release];
    [btFacebook release];
    [btTwitter release];
    [btHelperViewIn release];
    [super dealloc];
}

-(void) loginWithResult:(BOOL)_result {
    
}

- (void)viewFadeIn:(UIView *)view {
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
    [view setAlpha:1.0f];
    [UIView commitAnimations];
}

- (void)viewFadeOut:(UIView *)view {
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
    [view setAlpha:0.0f];
    [UIView commitAnimations];
}

- (IBAction)facebook:(id)sender{ 
    
    UIView *senderButton = (UIView*) sender;
    NSIndexPath *indexPath = [table indexPathForCell: (UITableViewCell*)[[senderButton superview]superview]];
    
    HistoryEntry *histEntry = [[[[ImmopolyManager instance] user] history] objectAtIndex: indexPath.row];
    
    
    [[FacebookManager getInstance] beginShare];
    
    [[FacebookManager getInstance] setFacebookTitle:sharingFacebookTitle];
    [[FacebookManager getInstance] setFacebookCaption:sharingFacebookCaption];
    [[FacebookManager getInstance] setFacebookDescription:sharingFacebookDescription];
    //[[FacebookManager getInstance] setFacebookImage:[selectedImmoscoutFlat pictureUrl]];
    [[FacebookManager getInstance] setFacebookLink:sharingFacebookLink];
    [[FacebookManager getInstance] setFacebookActionLabel:sharingFacebookActionLabel];
    [[FacebookManager getInstance] setFacebookActionText:[histEntry histText]];
    [[FacebookManager getInstance] setFacebookActionLink:sharingFacebookLink];
    //[[FacebookManager getInstance] setFacebookText:[selectedHistoryEntry histText]];
    
    [[FacebookManager getInstance] commitShare];
}

// methods to implement because of FaceBookManager
-(IBAction)performFacebookPost {}
- (void)facebookStartedLoading {}
- (void)facebookStopedLoading {}



- (IBAction)twitter:(id)sender{
    Class twitterClass = NSClassFromString(@"TWTweetComposeViewController");
    
    if(!twitterClass) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:sharingTwitterAPINotAvailableAlertTitle message:sharingTwitterAPINotAvailableAlertMessage delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else {
        if(![TWTweetComposeViewController canSendTweet]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:sharingTwitterNoAccountAlertTitle message:sharingTwitterNoAccountAlertMessage delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil];
            [alert show];
            [alert release]; 
        }
        else {
            
            UIView *senderButton = (UIView*) sender;
            NSIndexPath *indexPath = [table indexPathForCell: (UITableViewCell*)[[senderButton superview]superview]];
            
            HistoryEntry *histEntry = [[[[ImmopolyManager instance] user] history] objectAtIndex: indexPath.row];
            
            TWTweetComposeViewController *tweetView = [[TWTweetComposeViewController alloc] init];
            [tweetView setInitialText:[histEntry histText]];
            
            [self presentModalViewController:tweetView animated:YES];
        }
    }
}

/*- (IBAction)update{
    
    if(!loading){
        HistoryTask *task = [[[HistoryTask alloc] init] autorelease];
        task.delegate = self;
        task.refresh = YES;
        loading = YES;
        [task loadHistoryEintriesFrom:0 To:loadingHistoryEntriesStart];
        [reloadDataSpinner startAnimating];
    }
}*/

@end
