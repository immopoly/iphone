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
@synthesize badgesView;
@synthesize userImage;
@synthesize loading;


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
    //[super initHelperView];
    
    // setting the text of the helperView
    [super initHelperViewWithMode:INFO_USER];
}

- (void)viewDidAppear:(BOOL)animated {
    loginCheck.delegate = self;
    [loginCheck checkUserLogin];
    [super viewDidAppear:animated];
    
    NSData *imageData;
    
    imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"image"];
    if (imageData != nil) {
        userImage.image = [NSKeyedUnarchiver unarchiveObjectWithData: imageData];
        userImage.contentMode = UIViewContentModeScaleAspectFit;
        [userImage setBackgroundColor:[UIColor whiteColor]];
    }else{
        [self loadFacebookPicture];
    }
}

- (void)performActionAfterLoginCheck {
    [self stopSpinnerAnimation];
    
    ImmopolyUser *myUser = [[ImmopolyManager instance] user];
    
    if(myUser != nil) {
        [self setLabelTextsOfUser:myUser];
        [self displayBadges];
    }
}

- (void)displayBadges {
    NSArray *userBadges = [[[ImmopolyManager instance] user] badges];
    int posX = 17;
    
    if([userBadges count] > 0) {
        for (int i=0; i<[userBadges count]; i++) {
            UserBadge *badge = [userBadges objectAtIndex:i];
            NSURL *url = [NSURL URLWithString:[badge url]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [[[UIImage alloc] initWithData:data] autorelease];
            
            //AsynchronousImageView *imgView = [[AsynchronousImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            //[imgView loadImageFromURLString:[badge url] forFlat:nil];
            
            UIButton *btBadge = [UIButton buttonWithType:UIButtonTypeCustom];
            [btBadge setBackgroundImage:image forState:UIControlStateNormal];
            
            if (i%2 == 0) {
                btBadge.frame = CGRectMake(posX, 10, 60, 60);
            } else {
                btBadge.frame = CGRectMake(posX, 71, 60, 60);
                posX += 76;
            }
            [btBadge addTarget:self action:@selector(showBadgeText:) forControlEvents:UIControlEventTouchUpInside];
            [btBadge setTag: [userBadges indexOfObject:badge]];
            [badgesView addSubview:btBadge];
        }
    }
}

- (void)showBadgeText:(id)sender {
    NSArray *userBadges = [[[ImmopolyManager instance] user] badges];
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
    self.badgesView = nil;
    self.spinner = nil;
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
    [badgesView release];
    [spinner release];
    [super dealloc];
}

-(void)notifyMyDelegateView{
    loading = NO;
    [spinner stopAnimating];
    [spinner setHidden: YES];
    ImmopolyUser *myUser = [[ImmopolyManager instance] user];
    
    if(myUser != nil) {
        [self setLabelTextsOfUser:myUser];
        [self displayBadges];
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
    [numExposes setText: [ NSString stringWithFormat:@"%i von %i", [[_user portfolio] count], [_user maxExposes]]];
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


@end
