//
//  AbstractViewController.m
//  TestAbstractVC
//
//  Created by Tobias Buchholz on 29.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AbstractViewController.h"
#import "Constants.h"

@implementation AbstractViewController

@synthesize helperView;
@synthesize helperViewBubble;
@synthesize btHelperViewIn;
@synthesize helperBackground;
@synthesize helperScroll;
@synthesize helperTextImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    
    [self.helperView release];
    [self.helperBackground release];
    [self.helperScroll release];
    [self.helperTextImage release];
    [self.helperViewBubble release];
    [self.btHelperViewIn release];
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
    
    //[self initHelperView];
    [self initButton];
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
    helperView = [[UIView alloc] initWithFrame:CGRectMake(0, -370, 320, 370)];
    
    helperViewBubble = [[UIView alloc] initWithFrame:CGRectMake(18, 30, 283, 329)];

    helperBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"infotext_background"]];

    helperScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, 284, 310)];
    
    helperScroll.scrollEnabled = YES;

    helperScroll.showsVerticalScrollIndicator = NO;
    
    switch (_infoMode) {
        case 1:
            helperTextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"infotext_map"]];
            helperTextImage.frame = CGRectMake(0, 0, 283, 380);    
        break;
            
        case 2:
            helperTextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"infotext_portfolio"]];
            helperTextImage.frame = CGRectMake(0, 0, 284, 330);    
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
    NSLog(@"hpvin");
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
    CGPoint pos = helperView.center;
    pos.y = 217.0f;
    helperView.center = pos;
    [UIView commitAnimations];
}

- (void)helperViewOut {
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
    CGPoint pos = helperView.center;
    pos.y = -320.0f;
    helperView.center = pos;
    [UIView commitAnimations];
}

/*- (void)setHelperViewTitle:(NSString *)_viewTitle {
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 200, 30)];
    [lbTitle setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:(15.0)]];
    [lbTitle setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [lbTitle setTextColor:[UIColor blackColor]];
    [lbTitle setTextAlignment:UITextAlignmentCenter];
    [lbTitle setText:_viewTitle];
    
    [helperViewBubble addSubview:lbTitle];
}*/

- (void)setHelperViewTextWithFile:(int)_infoMode {
    

    
    /*switch (_infoMode) {
        case infoModeWelcome:
            
            break;
        
        case infoModeMap:
            
            break;
        
        case infoModePortfolio:
            
            break;
            
        case infoModeExpose:
            
            break;
            
        case infoModeHistory:
            
            break;
            
        default:
            break;
    }*/
    
    /*
    UITextView *tvText = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, 270, 250)];
    [tvText setEditable:NO];
    [tvText setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)]];
    [tvText setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [tvText setTextColor:[UIColor blackColor]];
    NSString *text = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource: _fileName ofType: @"html"] encoding:NSUTF8StringEncoding error:nil];
    [tvText setText:text];
    [helperViewBubble addSubview:tvText];
     */
    
    /*NSString *html = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource: _fileName ofType: @"html"] encoding:NSUTF8StringEncoding error:nil];
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(10, 50, 270, 250)];
    [webview loadHTMLString:html baseURL:nil];
    webview.backgroundColor = [UIColor whiteColor];
    [helperViewBubble addSubview:webview];*/
    
    
}
@end
