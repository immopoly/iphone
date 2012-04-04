//
//  UserProfileViewController.m
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 30.10.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import "UserProfileViewController.h"
#import "ImmopolyManager.h"
#import "ImmopolyUser.h"
#import "UserBadge.h"
#import "AsynchronousImageView.h"
#import "UserTask.h"
#import "ScrollViewItem.h"
#import "ActionItem.h"

#define BADGES_ACTIVE 0
#define ACTIONS_ACTIVE 1

@interface UserProfileViewController () {
    IBOutlet UIImageView *tabbarOtherUser;
    int activeScrollView;
}

@property(nonatomic, retain) UIImageView *tabbarOtherUser;
@property(nonatomic, assign) int activeScrollView;

- (void)initBackground:(int)_offset ofScrollView:(UIScrollView *)_scrollView;
- (void)showItemsText:(id)sender;
- (BOOL)shouldUpdateItems:(NSArray *)_items;

@end

@implementation UserProfileViewController

@synthesize hello;
@synthesize bank;
@synthesize miete;
@synthesize numExposes;
@synthesize loginCheck;
@synthesize labelBank;
@synthesize labelMiete;
@synthesize labelNumExposes;
@synthesize badgesScrollView;
@synthesize actionsScrollView;
@synthesize userImage;
@synthesize loading;
@synthesize userIsNotMyself;
@synthesize otherUserName;
@synthesize closeProfileButton;
@synthesize tabBar;
@synthesize topBarImage;
@synthesize otherUser;
@synthesize numberOfBadges;
@synthesize numberOfActions;
@synthesize itemsView;
@synthesize btShowBadges;
@synthesize btShowItems;
@synthesize tabbarOtherUser;
@synthesize activeScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"User", @"Third");
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_user"];
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
    self.loginCheck = [[[LoginCheck alloc]init] autorelease];
    
    [super initSpinner];
    [super.spinner startAnimating];
    
    // setting the text of the helperView
    [super initHelperViewWithMode:INFO_USER];
    
    self.badgesScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 320-43, 320, 132)];
    [[self view]addSubview:badgesScrollView];
    [[self view]bringSubviewToFront:[self badgesScrollView]];
 
    self.actionsScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 480, 320, 132)];
    [[self view]addSubview:actionsScrollView];
    [[self view]bringSubviewToFront:[self actionsScrollView]];
}

-(void)viewWillAppear:(BOOL)animated{

    [spinner setHidden:NO];
    [spinner startAnimating];
    [badgesViewBackground setHidden:NO];
    
    //TODO: reset labels
    if (userIsNotMyself) {
        
        [hello setText: @""];
        [bank setText: @""];
        [miete setText: @""];
        [numExposes setText: @""];
        
        //deleting all existing badges
        NSArray* subviews = [NSArray arrayWithArray: badgesScrollView.subviews];
        for (UIView* view in subviews) {
            [view removeFromSuperview];
        }
        
        [self prepareOtherUserProfile];
        [[self tabBar]setHidden:NO];
    }else{
        //That the badges can be clicked
        [[self view]sendSubviewToBack:[self tabBar]];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    if(userIsNotMyself){
        [super.spinner setHidden:NO];
        [super.spinner startAnimating];
        
        UserTask *task = [[UserTask alloc]init];
        task.delegate = self;
        [task refreshUser:otherUserName];
        
        [[self closeProfileButton] setHidden:NO];
        [[self closeProfileButton] setEnabled:YES];
    }else{
        loginCheck.delegate = self;
        [loginCheck checkUserLogin];
        [super viewDidAppear:animated];
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")){
            NSData *imageData;
            imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"facebook-image"];
            
            if(imageData != nil) {
                userImage.image = [NSKeyedUnarchiver unarchiveObjectWithData: imageData];
                userImage.contentMode = UIViewContentModeScaleAspectFit;
                [userImage setBackgroundColor:[UIColor whiteColor]];
            }else{
                [self loadFacebookPicture];    
            }
        }
    }
}

- (void)performActionAfterLoginCheck {
    ImmopolyUser *myUser = [[ImmopolyManager instance] user];
    
    if(myUser != nil) {
        [self setLabelTextsOfUser:myUser];
//        [self displayBadges:myUser];
        
        [self displayItems:[myUser badges] ofScrollView:badgesScrollView];
        [self displayItems:[myUser actionItems] ofScrollView:actionsScrollView];
    }
    [self stopSpinnerAnimation];
}

/*
- (void)displayBadges:(ImmopolyUser *)_user{
    
    NSMutableArray *userBadges = [_user badges];
    
    if(([userBadges count] > 0 && numberOfBadges != [userBadges count]) || userIsNotMyself) {
        
         FOR TESTING
        UserBadge *test = [userBadges objectAtIndex:0];
        for (int k=0; k<40; k++) [userBadges addObject:test];
        
        
        [self setNumberOfBadges:[userBadges count]];
        
        int posX = 0;
        int userBadgesCount;
        
        // setting the whole size of the scrollView
        int scrollviewSize;
        if ([userBadges count]%8 == 0) {
            scrollviewSize = [userBadges count]/8;
        } else {
            scrollviewSize = [userBadges count]/8 + 1;
        }
            
        // configure the scrollview
        self.badgesScrollView.contentSize = CGSizeMake(self.badgesScrollView.frame.size.width * scrollviewSize, self.badgesScrollView.frame.size.height);
        [self.badgesScrollView setPagingEnabled:YES];
        [self.badgesScrollView setShowsHorizontalScrollIndicator:NO];
        [self.badgesScrollView setBounces:NO];
 
        // sets the scrollview page to the first
        [badgesScrollView setContentOffset:CGPointMake(0, 0)];
        
        
        for(int j=0; j<scrollviewSize; j++) {
            posX += 12;
            UIImageView *badgesBackground = [[UIImageView alloc]initWithFrame:CGRectMake(j*320, 0, 320, 132)];
            [badgesBackground setImage:[UIImage imageNamed:@"badgesview"]];
            [self.badgesScrollView addSubview:badgesBackground];
            
            // determine how often the second for-loop should iterate
            if([userBadges count] > (j+1)*8 || [userBadges count]%8 == 0) {
                userBadgesCount = 8;    
            } else {
                userBadgesCount = [userBadges count]%8;
            }
            
            for (int i=0; i<userBadgesCount; i++) {
                UserBadge *badge = [userBadges objectAtIndex:i+(j*8)];
                AsynchronousImageView *imgView = [[AsynchronousImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
                [imgView setShouldBeSaved:NO];
                [imgView setOwnBgColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]];
                [imgView loadImageFromURLString:[badge url] forFlat:nil];
                
                UIButton *btBadge = [UIButton buttonWithType:UIButtonTypeCustom];
                [btBadge setBackgroundImage:[UIImage imageNamed:@"btBadge_selected.png"] forState:UIControlStateHighlighted];
                
                if (i%2 == 0) {
                    btBadge.frame = CGRectMake(posX, 6, 70, 70);
                    [imgView setCenter:btBadge.center];
                } else {
                    btBadge.frame = CGRectMake(posX, 66, 70, 70);
                    [imgView setCenter:btBadge.center];
                    posX += 76;
                }
                [btBadge addTarget:self action:@selector(showBadgeText:) forControlEvents:UIControlEventTouchUpInside];
                [btBadge setTag: [userBadges indexOfObject:badge]];
                [badgesScrollView bringSubviewToFront:btBadge];
                [badgesScrollView addSubview:imgView];
                [badgesScrollView addSubview:btBadge];
            }
            posX += 4;
            [badgesBackground release];
        }
    }
}
*/

- (void)displayItems:(NSArray *)_items ofScrollView:(UIScrollView *)_scrollView{
    // show empty scrollview
    if([_items count] == 0) {
        [self initBackground:0 ofScrollView:_scrollView]; 
    }
    
    if([self shouldUpdateItems:_items] || userIsNotMyself) {
        
        [[self view] bringSubviewToFront:tabbarOtherUser];
        
        int posX = 0;
        int itemsCount;
        
        // setting the whole size of the scrollView
        int scrollviewSize;
        if ([_items count]%8 == 0) {
            scrollviewSize = [_items count]/8;
        } else {
            scrollviewSize = [_items count]/8 + 1;
        }
        
        // configure the scrollview
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * scrollviewSize, _scrollView.frame.size.height);
        [_scrollView setPagingEnabled:YES];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setBounces:NO];
        
        // sets the scrollview page to the first
        [_scrollView setContentOffset:CGPointMake(0, 0)];
        
        for(int j=0; j<scrollviewSize; j++) {
            posX += 12;
            [self initBackground:j ofScrollView:_scrollView];
            
            // determine how often the second for-loop should iterate
            if([_items count] > (j+1)*8 || [_items count]%8 == 0) {
                itemsCount = 8;    
            } else {
                itemsCount = [_items count]%8;
            }
            
            for (int i=0; i<itemsCount; i++) {
                ScrollViewItem *item = [_items objectAtIndex:i+(j*8)];
                AsynchronousImageView *imgView = [[AsynchronousImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
                [imgView setShouldBeSaved:NO];
                [imgView setOwnBgColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]];
                [imgView loadImageFromURLString:[item url] forFlat:nil];
                
                UIButton *btItem = [UIButton buttonWithType:UIButtonTypeCustom];
                [btItem setBackgroundImage:[UIImage imageNamed:@"btBadge_selected.png"] forState:UIControlStateHighlighted];
                
                if (i%2 == 0) {
                    btItem.frame = CGRectMake(posX, 6, 70, 70);
                    [imgView setCenter:btItem.center];
                } else {
                    btItem.frame = CGRectMake(posX, 66, 70, 70);
                    [imgView setCenter:btItem.center];
                    posX += 76;
                }
                [btItem addTarget:self action:@selector(showItemsText:) forControlEvents:UIControlEventTouchUpInside];
                [btItem setTag: [_items indexOfObject:item]];
                [_scrollView bringSubviewToFront:btItem];
                [_scrollView addSubview:imgView];
                [_scrollView addSubview:btItem];
            }
            posX += 4;
        } 
    } 
}

// compares the actual number of badges/actions with the stored one from last visit at userprofile 
- (BOOL)shouldUpdateItems:(NSArray *)_items {
    
    if ([_items count] > 0) {
        if([[_items objectAtIndex:0] isKindOfClass:[UserBadge class]]) {
            if(numberOfBadges == [_items count]) {
                return NO;    
            } else {
                numberOfBadges = [_items count];
                return YES;
            }
        }
        if([[_items objectAtIndex:0] isKindOfClass:[ActionItem class]]) {
            if(numberOfActions == [_items count]) {
                return NO;
            } else {
                numberOfActions = [_items count];
                return YES;
            }
        }
    }
    return YES;
}

// initializes the empty background of the given scrollview
- (void)initBackground:(int)_offset ofScrollView:(UIScrollView *)_scrollView {
    UIImageView *scrollViewBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0*_offset, 0, 320, 132)];
    [scrollViewBackground setImage:[UIImage imageNamed:@"badgesview"]];
    [_scrollView addSubview:scrollViewBackground];
    [scrollViewBackground release];
}

/*
- (void)showBadgeText:(id)sender {
    
    NSArray *userBadges = NULL;
    
    if (userIsNotMyself) {
        userBadges = [[self otherUser]badges];
    }else{
       userBadges = [[[ImmopolyManager instance] user] badges];     
    }

    NSString *badgeText = [[userBadges objectAtIndex:[sender tag]] text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:badgeText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release]; 
}
*/

- (void)showItemsText:(id)sender {
    
    NSArray *items = NULL;
    
    if(activeScrollView == BADGES_ACTIVE) {
        if (userIsNotMyself) {
            items = [[self otherUser]badges];
        }else{
            items = [[[ImmopolyManager instance] user] badges];     
        }    
    } else {
        items = [[[ImmopolyManager instance] user] actionItems];     
    }
    
    NSString *badgeText = [[items objectAtIndex:[sender tag]] text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:badgeText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release]; 
}

- (void)viewDidUnload {
    [super viewDidUnload];  
    
    self.hello = nil;
    self.bank = nil;
    self.miete = nil;
    self.numExposes = nil;
    self.labelBank = nil;
    self.labelMiete = nil;
    self.labelNumExposes = nil;
    self.badgesScrollView = nil;
    self.closeProfileButton = nil;
    self.tabBar = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc {
    [hello release];
    [bank release];
    [miete release];
    [numExposes release];
    [loginCheck release];
    [labelBank release];
    [labelMiete release];
    [labelNumExposes release];
    [badgesScrollView release];
    [super dealloc];
}

-(void)notifyMyDelegateView{
    loading = NO;
    //[spinner stopAnimating];
    //[spinner setHidden: YES];
    ImmopolyUser *myUser = [[ImmopolyManager instance] user];
    
    if(myUser != nil) {
        [self setLabelTextsOfUser:myUser];
        //[self displayBadges:myUser];
        
        [self displayItems:[myUser badges] ofScrollView:badgesScrollView];
        [self displayItems:[myUser actionItems] ofScrollView:actionsScrollView];
    }
}

- (void)setLabelTextsOfUser:(ImmopolyUser *)_user; {
    NSString *balance = [NSString stringWithFormat:@"%.2f €",[_user balance]];
    NSString *lastRent = [NSString stringWithFormat:@"%.2f €",[_user lastRent]];
    
    [hello setText: [NSString stringWithFormat: @"%@", [_user userName]]];
    [bank setText: balance];
    [miete setText: lastRent];
    [numExposes setText: [ NSString stringWithFormat:@"%i von %i", [_user numExposes], [_user maxExposes]]];
}

- (void)loadFacebookPicture {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    long long uid = [[defaults objectForKey:@"FBUserId"] longLongValue];
    if (uid>0) {
        [userImage setHidden:NO];
        
        NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%qi/picture?type=large", uid];
        
        [userImage setOwnBgColor:[UIColor whiteColor]];
        [userImage setShouldBeSaved:YES];
        [userImage loadImageFromURLString:urlString forFlat:nil];
        userImage.contentMode = UIViewContentModeScaleAspectFit;
    }
}

- (void)imagePickerController:(UIImagePickerController *)_picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissModalViewControllerAnimated:YES];
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image != nil) {
        [userImage setHidden:NO];
        [userImage setImage:image];
        userImage.contentMode = UIViewContentModeScaleAspectFit;
        
        NSData *imageData;
        
        // create NSData-object from image
        imageData = [NSKeyedArchiver archivedDataWithRootObject:image];
        // save NSData-object to UserDefaults
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"image"];
    }
    
    [picker release];
    
}

- (IBAction)changeProfilePic{
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    [self presentModalViewController:picker animated:YES];

}

-(void)notifyMyDelegateViewWithUser:(ImmopolyUser *)user{
    [self setLabelTextsOfUser:user];
    //[self displayBadges:user];
    [self displayItems:[user badges] ofScrollView:badgesScrollView];
    if(!userIsNotMyself){
        [self displayItems:[user actionItems] ofScrollView:actionsScrollView];    
    }
    [self setOtherUser:user];
    [super.spinner setHidden:YES];
    
}

- (IBAction)closeProfile{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)prepareOtherUserProfile {
    // setting the text of the helperView
    [super initHelperViewWithMode:INFO_OTHER_USER];
    
    [topBarImage setImage:[UIImage imageNamed:@"top_bar_other_user.png"]];
    [closeProfileButton setHidden:NO];
    
    //moving the button to the right site
    CGPoint posBt = btHelperViewIn.center; 
    posBt.x = 300.0f;
    [btHelperViewIn setCenter:posBt];
    
    // moving the spinner a bit more to the left
    CGPoint posSpinner = super.spinner.center;
    posSpinner.x = 265.0f;
    [super.spinner setCenter:posSpinner];
    
    [btShowItems setHidden:YES];
    [btShowBadges setHidden:YES];
}

- (void)closeMyDelegateView {}

- (IBAction)toggleBadgesAndItemsView:(id)_sender {
    [badgesViewBackground setHidden:YES];
    CGPoint posBV = badgesScrollView.center;
    CGPoint posAV = actionsScrollView.center;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    
    if([_sender tag] == 1) {
        posBV.y = 343;
        posAV.y = 546;
        activeScrollView = BADGES_ACTIVE;
    } else {
        posBV.y = 546;
        posAV.y = 343;
        activeScrollView = ACTIONS_ACTIVE;
    }
    
    [badgesScrollView setCenter:posBV];
    [actionsScrollView setCenter:posAV];
    
    [UIView commitAnimations];
}
@end
