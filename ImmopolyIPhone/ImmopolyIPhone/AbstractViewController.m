//
//  AbstractViewController.m
//  TestAbstractVC
//
//  Created by Tobias Buchholz on 29.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AbstractViewController.h"

@implementation AbstractViewController

@synthesize helperView;
@synthesize helperViewBubble;
@synthesize btHelperViewIn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    // Do any additional setup after loading the view from its nib.
    
    [self initHelperView];
    [self initButton];
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

- (void)initButton {
    btHelperViewIn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btHelperViewIn addTarget:self action:@selector(helperViewIn) forControlEvents:UIControlEventTouchUpInside];
    btHelperViewIn.frame = CGRectMake(0, 0, 40, 40);
    [[self view] addSubview:btHelperViewIn];
}

- (void)initHelperView {
    helperView = [[UIView alloc] initWithFrame:CGRectMake(0, -370, 320, 370)];
    
    helperViewBubble = [[UIView alloc] initWithFrame:CGRectMake(20, 30, 280, 310)];
    helperViewBubble.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(helperViewOut) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(240, 10, 30, 30);
    
    [helperViewBubble addSubview:button];
    [helperView addSubview:helperViewBubble];
    [[self view] addSubview:helperView];
}

- (void)helperViewIn {
    NSLog(@"hpvin");
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
    CGPoint pos = helperView.center;
    pos.y = 230.0f;
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

- (void)setHelperViewTitle:(NSString *)_viewTitle {
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 200, 30)];
    [lbTitle setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:(15.0)]];
    [lbTitle setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [lbTitle setTextColor:[UIColor blackColor]];
    [lbTitle setTextAlignment:UITextAlignmentCenter];
    [lbTitle setText:_viewTitle];
    
    [helperViewBubble addSubview:lbTitle];
}

- (void)setHelperViewTextWithFile:(NSString *)_fileName {
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
    NSString *html = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource: _fileName ofType: @"html"] encoding:NSUTF8StringEncoding error:nil];
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(10, 50, 270, 250)];
    [webview loadHTMLString:html baseURL:nil];
    webview.backgroundColor = [UIColor whiteColor];
    [helperViewBubble addSubview:webview];
}
@end
