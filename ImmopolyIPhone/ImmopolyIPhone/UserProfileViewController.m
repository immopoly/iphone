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

@implementation UserProfileViewController

@synthesize hello;
@synthesize bank;
@synthesize miete;
@synthesize numExposes;
@synthesize loginCheck;
@synthesize spinner;
@synthesize labelBank;
@synthesize labelMiete;
@synthesize labelNumExposes;
@synthesize badgesScrollView;
@synthesize userImage;
@synthesize loading;
@synthesize userIsNotMyself;
@synthesize otherUserName;
@synthesize closeProfileButton;
@synthesize tabBar;
@synthesize topBarImage;
@synthesize otherUser;
//@synthesize badgesBackground;
@synthesize numberOfBadges;


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
    
    [spinner startAnimating];
    
    // setting the text of the helperView
    [super initHelperViewWithMode:INFO_USER];
    
    self.badgesScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 320-43, 320, 132)];
    [[self view]addSubview:badgesScrollView];
    [[self view]bringSubviewToFront:[self badgesScrollView]];
}

-(void)viewWillAppear:(BOOL)animated{

    [spinner setHidden:NO];
    [spinner startAnimating];
    
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
    
    /*
    if ([self badgesScrollView] !=NULL) {
        [[self badgesScrollView]release];
    }
     */
}

- (void)viewDidAppear:(BOOL)animated {
    
    if(userIsNotMyself){
        [spinner setHidden:NO];
        [spinner startAnimating];
        
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
            imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"image"];
            
            if(imageData != nil)
            {
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
        [self displayBadges:myUser];
    }
    [self stopSpinnerAnimation];
}

- (void)displayBadges:(ImmopolyUser *)_user{
    
    NSMutableArray *userBadges = [_user badges];
    
    if(([userBadges count] > 0 && numberOfBadges != [userBadges count]) || userIsNotMyself) {
        
        /* FOR TESTING
        UserBadge *test = [userBadges objectAtIndex:0];
        for (int k=0; k<10; k++) [userBadges addObject:test];
        */
        
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
            posX += 16;
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
                NSURL *url = [NSURL URLWithString:[badge url]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image = [[[UIImage alloc] initWithData:data] autorelease];
                
                //AsynchronousImageView *imgView = [[AsynchronousImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
                //[imgView loadImageFromURLString:[badge url] forFlat:nil];
                
                UIButton *btBadge = [UIButton buttonWithType:UIButtonTypeCustom];
                [btBadge setBackgroundImage:image forState:UIControlStateNormal];
                //[btBadge addSubview:imgView];
                
                if (i%2 == 0) {
                    btBadge.frame = CGRectMake(posX, 10, 60, 60);
                } else {
                    btBadge.frame = CGRectMake(posX, 71, 60, 60);
                    posX += 76;
                }
                [btBadge addTarget:self action:@selector(showBadgeText:) forControlEvents:UIControlEventTouchUpInside];
                [btBadge setTag: [userBadges indexOfObject:badge]];
                [badgesScrollView bringSubviewToFront:btBadge];
                [badgesScrollView addSubview:btBadge];
            }
            [badgesBackground release];
        }
    }
}

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

- (void)stopSpinnerAnimation {
    [spinner stopAnimating];
    [spinner setHidden: YES];
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
    self.spinner = nil;
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
    [spinner release];
//    [badgesBackground release];
    [super dealloc];
}

-(void)notifyMyDelegateView{
    loading = NO;
    //[spinner stopAnimating];
    //[spinner setHidden: YES];
    ImmopolyUser *myUser = [[ImmopolyManager instance] user];
    
    if(myUser != nil) {
        [self setLabelTextsOfUser:myUser];
        [self displayBadges:myUser];
    }
}

/*- (IBAction)update{
    [spinner setHidden: NO];
    if(!loading){
        UserTask *task = [[[UserTask alloc] init] autorelease];
        task.delegate = self;
        loading = YES;
        
        [task refreshUser:[[ImmopolyManager instance]user].userName];
        [spinner startAnimating];
    }
}*/

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
        NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%qi/picture?type=large", uid];
        
        [userImage loadImageFromURLString:urlString forFlat:nil];
        userImage.contentMode = UIViewContentModeScaleAspectFit;
    }
}

- (void)imagePickerController:(UIImagePickerController *)_picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissModalViewControllerAnimated:YES];
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image != nil) {
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
    [self displayBadges:user];
    [self setOtherUser:user];
    [spinner setHidden:YES];
    
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
    CGPoint posSpinner = spinner.center;
    posSpinner.x = 265.0f;
    [spinner setCenter:posSpinner];
}

- (void)closeMyDelegateView {}

@end
