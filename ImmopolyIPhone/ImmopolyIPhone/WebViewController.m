//
//  WebViewController.m
//  Created by Tobias Heine.
//

#import "WebViewController.h"
#import "ImmopolyManager.h"
#import "FlatTakeOverTask.h"
#import "FlatRemoveTask.h"

@implementation WebViewController

@synthesize webView,activityIndicator,selectedExposeId,selectedImmoscoutFlat, loginCheck,flatActionButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
        self.loginCheck = [[LoginCheck alloc] init];
	}
	return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */

/*
 If you need to do additional setup after loading the view, override viewDidLoad. */
- (void)viewDidLoad {
	[self reloadData];
}

-(void)reloadData{
    NSString *urlAddress = [[NSString alloc]initWithFormat:@"http://mobil.immobilienscout24.de/expose/%i",[selectedImmoscoutFlat exposeId]];
	//NSString *urlAddress = @"http://mobil.immobilienscout24.de/expose/";
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
    [urlAddress release];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
    
    if ([[[[ImmopolyManager instance]user]portfolio]containsObject:[self selectedImmoscoutFlat]]) {
        [flatActionButton setTitle: @"Wohnung abgeben" forState: UIControlStateNormal];
    }else{
        [flatActionButton setTitle: @"Wohnung übernehmen" forState: UIControlStateNormal];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[webView release];
    [activityIndicator release];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [loginCheck release];
	[super dealloc];
}

-(IBAction)goBack{
    [self.view removeFromSuperview];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [activityIndicator startAnimating];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
    activityIndicator.hidden=YES;
}

-(IBAction)flatAction{
     
    //FlatTakeOverTask *flatTask = [[FlatTakeOverTask alloc]init];
    //[flatTask takeOverFlat:[self selectedImmoscoutFlat]];
    loginCheck.delegate = self;
    [loginCheck checkUserLogin];
}

-(void) displayUserData {
    
    if ([[[[ImmopolyManager instance]user]portfolio]containsObject:[self selectedImmoscoutFlat]]) {
        FlatRemoveTask *flatRemoveTask = [[FlatRemoveTask alloc]init];
        [flatRemoveTask removeFlat:[self selectedImmoscoutFlat]];
    }else{
        FlatTakeOverTask *flatTask = [[FlatTakeOverTask alloc]init];
        [flatTask takeOverFlat:[self selectedImmoscoutFlat]];
    }
    
    [self.view removeFromSuperview];
    
}

@end
