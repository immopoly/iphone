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
@synthesize loading;
@synthesize flagForReload;
@synthesize loadingHistoryEntriesLimit;
@synthesize loadingHistoryEntriesStart;
@synthesize lbTime;
@synthesize lbText;
@synthesize btFacebook;
@synthesize btTwitter;
@synthesize btOpenProfile;
@synthesize lblImage;
@synthesize userVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"History", @"Fourth");
        [[self tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_icon_history"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_icon_history"]];
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
    [super initSpinner];
    [[self table] setHidden: YES];
    [self.table setBackgroundColor:[UIColor clearColor]];
    [self.table setSeparatorColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0]];
    
    loadingHistoryEntriesStart = 10;
    loadingHistoryEntriesLimit = 10;
    
    [super.spinner stopAnimating];
    
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
    
    userVC = [[UserProfileViewController alloc]init];
}


-(void)viewWillAppear:(BOOL)animated{
    [[self table]reloadData];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super.spinner startAnimating];
    loginCheck.delegate = self;
    [loginCheck checkUserLogin];
    
    [super viewDidAppear:animated];
}

- (void)performActionAfterLoginCheck {
    [table reloadData];
    [super stopSpinnerAnimation];
    [[self table] setHidden: NO];
    
    if ([[[ImmopolyManager instance]user]history] == nil || [[[[ImmopolyManager instance]user]history]count]<=0) {
        [super helperViewIn];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.tvCell = nil;
    self.table = nil;
    self.lbText = nil;
    self.lbTime = nil;
    self.btFacebook = nil;
    self.btTwitter = nil;
    self.btHelperViewIn = nil;
    self.btOpenProfile = nil;
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

-(IBAction)showCellLabels:(id)sender{
    
    UIView *senderButton = (UIView*) sender;
    NSIndexPath *indexPath = [table indexPathForCell: (UITableViewCell*)[senderButton superview]];
    UITableViewCell *selectedCell = [table cellForRowAtIndexPath:indexPath];
    
    lbTime = (UILabel *)[selectedCell viewWithTag:1];
    lbText = (UILabel *)[selectedCell viewWithTag:2];
    btFacebook = (UIButton *)[selectedCell viewWithTag:5];
    btTwitter = (UIButton *)[selectedCell viewWithTag:6];
    btOpenProfile = (UIButton *)[selectedCell viewWithTag:7];
    
    HistoryEntry *histEntry = [[[[ImmopolyManager instance] user] history] objectAtIndex: indexPath.row];
    
    if ([histEntry isSharingActivated]) {
        [histEntry setIsSharingActivated:NO];
        [self viewFadeIn:lbTime];
        [self viewFadeIn:lbText];
        [self viewFadeOut:btFacebook];
        [self viewFadeOut:btTwitter]; 
        [self viewFadeOut:btOpenProfile];
    }else{
        [histEntry setIsSharingActivated:YES];
        [self viewFadeOut:lbTime];
        [self viewFadeOut:lbText];
        [self viewFadeIn:btFacebook];
        [self viewFadeIn:btTwitter];
        [self viewFadeIn:btOpenProfile];
    }
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
    lblImage = (UIImageView *)[cell viewWithTag:3];
    btFacebook = (UIButton *)[cell viewWithTag:5];
    btTwitter = (UIButton *)[cell viewWithTag:6];
    btOpenProfile = (UIButton *)[cell viewWithTag:7];

    [btOpenProfile setEnabled:NO];
    
    //ToDo: Besser machen...
    UIButton *showOptionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[showOptionsButton addTarget:self 
			   action:@selector(showCellLabels:)
	 forControlEvents:UIControlEventTouchDown];
	[showOptionsButton setTitle:@"" forState:UIControlStateNormal];
	showOptionsButton.frame = CGRectMake(22.0f, 35.0f, 35.0f, 35.0f);
    
	[cell addSubview:showOptionsButton];
    
    
    // fetching the selected history entry
    HistoryEntry *historyEntry;
    if ([[[[ImmopolyManager instance] user] history] count] > 0) {
        historyEntry = [[[[ImmopolyManager instance] user] history] objectAtIndex: indexPath.row];
        
        // Convert string to date object
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CET"]];
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
            [btFacebook setAlpha:1.0f];
            [btTwitter setAlpha:1.0f];
            [btOpenProfile setAlpha:1.0];
        } else {
            [lbTime setAlpha:1.0f];
            [lbText setAlpha:1.0f];
            [btFacebook setAlpha:0.0f];
            [btTwitter setAlpha:0.0f];
            [btOpenProfile setAlpha:0.0];
        }
        
        // setting text
        [lbTime setText: formattedDateString]; 
        [lbText setText: [historyEntry histText]];
        
        if ([[historyEntry otherUserName]length]>0) {
            [btOpenProfile setEnabled:YES];
        }
    } 
    else {
        NSLog(@"user history object is empty!");
        [lbTime setHidden: YES];
        [lbText setHidden: YES];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if ([indexPath row]>[[[[ImmopolyManager instance] user] history] count]-3 && [[[[ImmopolyManager instance] user] history] count]>9) {
        if (loading) {
            flagForReload = YES;
        }else{
            flagForReload = NO;
            loading = YES;
            
            HistoryTask *task = [[[HistoryTask alloc] init] autorelease];
            task.delegate = self;
            [task loadHistoryEintriesFrom:loadingHistoryEntriesStart To:(loadingHistoryEntriesStart+loadingHistoryEntriesLimit)];
            [super.spinner startAnimating];
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
            [super.spinner startAnimating];
        }
      }
    
    return cell;
}

- (void)hasMoreData:(bool)result {
    if (result) {
        loading = false;
    }
    [self.table reloadData];
    [super.spinner stopAnimating];
}

- (void)dealloc {
    [tvCell release];
    [table release];
    [loginCheck release];
    [lbTime release];
    [lbText release];
    [btFacebook release];
    [btTwitter release];
    //[btHelperViewIn release];
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

- (IBAction)openUserProfile:(id)sender{ 
    UIView *senderButton = (UIView*) sender;
    NSIndexPath *indexPath = [table indexPathForCell: (UITableViewCell*)[[senderButton superview]superview]];
    
    HistoryEntry *histEntry = [[[[ImmopolyManager instance] user] history] objectAtIndex: indexPath.row];
    NSString *userName = [histEntry otherUserName];
       
    //ToDo: set userName to ViewController
    //load & display profile
    [userVC setOtherUserName:userName];
    [userVC setUserIsNotMyself:YES];
    userVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:userVC animated:YES];
}

- (IBAction)facebook:(id)sender{ 
    
    UIView *senderButton = (UIView*) sender;
    NSIndexPath *indexPath = [table indexPathForCell: (UITableViewCell*)[[senderButton superview]superview]];
    
    HistoryEntry *histEntry = [[[[ImmopolyManager instance] user] history] objectAtIndex: indexPath.row];
    
    
    [[FacebookManager getInstance] beginShare];
    
    //[[FacebookManager getInstance] setFacebookText:[histEntry histText]];
    [[FacebookManager getInstance] setFacebookTitle:sharingFacebookTitle];
    [[FacebookManager getInstance] setFacebookCaption:[histEntry histText]];
    [[FacebookManager getInstance] setFacebookDescription:sharingFacebookDescription];
    [[FacebookManager getInstance] setFacebookImage:@"http://www.tobiasheine.eu/Immopoly_big.png"];
    [[FacebookManager getInstance] setFacebookLink:sharingFacebookLink];
    [[FacebookManager getInstance] setFacebookActionLabel:sharingFacebookActionLabel];
    [[FacebookManager getInstance] setFacebookActionText:@"www.immobilienscout24.de"];
    [[FacebookManager getInstance] setFacebookActionLink:@"http://www.immobilienscout24.de"];
    
    //
    
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
            
            NSString *tweetText = [NSString stringWithFormat:@"@immopoly %@",[histEntry histText]];
            if ([tweetText length]>140) {
                tweetText = [tweetText substringToIndex:137];
                tweetText = [tweetText stringByAppendingString:@"..."];
            }
            
            [tweetView setInitialText:tweetText];
            
            [self presentModalViewController:tweetView animated:NO];
        }
    }
}

@end
