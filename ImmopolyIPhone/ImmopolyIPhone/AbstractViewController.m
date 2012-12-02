//
//  AbstractViewController.m
//  TestAbstractVC
//
//  Created by Tobias Buchholz on 29.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AbstractViewController.h"
#import "Constants.h"
#import "ImmopolyManager.h"
#import "AppDelegate.h"
#import "ActionItemButton.h"

@implementation AbstractViewController

@synthesize helperView;
@synthesize helperViewBubble;
@synthesize btHelperViewIn;
@synthesize helperBackground;
@synthesize helperScroll;
@synthesize helperTextImage;
@synthesize viewIsVisible; 
@synthesize linkButton;
@synthesize spinner;
@synthesize selectedActionItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    self.helperView = nil;
    self.helperBackground = nil;
    self.helperScroll = nil;
    self.helperTextImage = nil;
    self.helperViewBubble = nil;
    self.btHelperViewIn = nil;
    self.linkButton = nil;
    self.spinner = nil;
    self.selectedActionItem = nil;
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
    
    [self initButton];
}

- (void) initSpinner {
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [spinner setHidden:NO];
    [spinner setCenter:CGPointMake(291, 21)];
    [[self view] addSubview:spinner];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.helperView = nil;
    self.helperBackground = nil;
    self.helperScroll = nil;
    self.helperTextImage = nil;
    self.helperViewBubble = nil;
    self.btHelperViewIn = nil;
    self.linkButton = nil;
    self.spinner = nil;
    self.selectedActionItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)initButton {
    btHelperViewIn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btHelperViewIn addTarget:self action:@selector(helperViewIn) forControlEvents:UIControlEventTouchUpInside];
    btHelperViewIn.frame = CGRectMake(0, 0, 40, 40);
    [[self view] addSubview:btHelperViewIn];
}

- (void)initHelperViewWithMode:(int)_infoMode {
    self.helperView = [[[UIView alloc] initWithFrame:CGRectMake(0, -370, 320, 370)] autorelease];
    
    self.helperViewBubble = [[[UIView alloc] initWithFrame:CGRectMake(18, 30, 283, 329)] autorelease];

    self.helperBackground = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"infotext_background"]] autorelease];

    self.helperScroll = [[[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, 284, 310)] autorelease];
    
    helperScroll.scrollEnabled = YES;

    helperScroll.showsVerticalScrollIndicator = NO;
    
    linkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [linkButton addTarget:self action:@selector(openImmopolyWeb) forControlEvents:UIControlEventTouchUpInside];
    
    switch (_infoMode) {
        case INFO_IMMOPOLY:
            helperTextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"infotext_immopoly"]];
            helperTextImage.frame = CGRectMake(0, 0, 283, 370);    
            
            linkButton.frame = CGRectMake(12, 274, 35, 20);
            [helperScroll addSubview:linkButton];
            
            break;
        
        case INFO_MAP:
            helperTextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"infotext_map"]];
            helperTextImage.frame = CGRectMake(0, 0, 283, 608);    
        break;
            
        case INFO_PORTFOLIO:
            helperTextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"infotext_portfolio"]];
            helperTextImage.frame = CGRectMake(0, 0, 284, 420);    
        break;
            
        case INFO_EXPOSE:
            helperTextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"infotext_expose"]];
            helperTextImage.frame = CGRectMake(0, 0, 284, 657);    

            linkButton.frame = CGRectMake(142, 367, 35, 20);
            [helperScroll addSubview:linkButton];
            break;
        case INFO_HISTORY: 
            helperTextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"infotext_history"]];
            helperTextImage.frame = CGRectMake(0, 0, 283, 553); 
            break;
        case INFO_USER: 
            helperTextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"infotext_user"]];
            helperTextImage.frame = CGRectMake(0, 0, 284, 481);     
            break;
        case INFO_OTHER_USER: 
            helperTextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"infotext_otherUser"]];
            helperTextImage.frame = CGRectMake(0, 0, 283, 357);     
            break;
        case INFO_FEEDBACK: 
            helperTextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"infotext_feedback"]];
            helperTextImage.frame = CGRectMake(0, 0, 283, 335);     
            break;
        default:
            break;
    }
    
    
    
    helperScroll.contentSize = CGSizeMake(helperTextImage.frame.size.width, helperTextImage.frame.size.height-10);
    
    [helperScroll addSubview:helperTextImage];
    
    [helperViewBubble addSubview:helperBackground];
    
    [helperViewBubble addSubview:helperScroll];    
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(helperViewOut) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"close_info_button"] forState:UIControlStateNormal];
    
    button.frame = CGRectMake(228, 5, 50, 52);
    
    [helperViewBubble addSubview:button];
    [helperView addSubview:helperViewBubble];
    [[self view] addSubview:helperView];
}

- (void)helperViewIn {
    if (![self viewIsVisible]) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        CGPoint pos = helperView.center;
        pos.y = 217.0f;
        helperView.center = pos;
        [UIView commitAnimations];
        
        [self setViewIsVisible:YES];
        [btHelperViewIn setEnabled:NO];
        [self.view bringSubviewToFront:helperView];
    }
}

- (void)helperViewOut {
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
    CGPoint pos = helperView.center;
    pos.y = -320.0f;
    helperView.center = pos;
    [UIView commitAnimations];
    
    [self setViewIsVisible:NO];
    [btHelperViewIn setEnabled:YES];
}

-(void)openImmopolyWeb{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://immopoly.org/description.html"]];
    [[ImmopolyManager instance]setWillComeBack:YES];
    
}

- (void)stopSpinnerAnimation {
    [spinner stopAnimating];
    [spinner setHidden: YES];
}

- (IBAction)performUserAction:(id)sender{
    ActionItem *item = [(ActionItemButton *)sender item];
    
    [self setSelectedActionItem:item];
    
    NSString *alertString = [[NSString alloc]initWithFormat:@"%@. Möchtest du die Aktion ausführen?",[item text]];
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Aktion ausführen" message:alertString delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Ja", nil];

    
    [alert show];
    [alert release];
    
    [alertString release];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    
    if([title isEqualToString:@"Ja"])
    {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        ActionItem *item = [self selectedActionItem];
        
        if ([item amount] > 0) {
            [item setAmount:[item amount] -1];
            [[delegate actionItemManager]setCurrentItem:item];
            [[delegate actionItemManager]useCurrentActionItem];
        }
        
        UIButton *sender = (UIButton *)[self.view viewWithTag:[item type]];

        
        if ([item amount] == 0) {
            [sender removeFromSuperview];
        }
    }else if([title isEqualToString:@"Nein"]){
        [self setSelectedActionItem:NULL];
    }
    
}

@end
