//
//  WebViewController.m
//  Created by Tobias Heine.
//

#import "WebViewController.h"
#import "ImmopolyManager.h"
#import "FlatTakeOverTask.h"

@implementation WebViewController

@synthesize webView,activityIndicator,selectedExposeId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
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
	
    NSString *urlAddress = [[NSString alloc]initWithFormat:@"http://mobil.immobilienscout24.de/expose/%i",selectedExposeId];
	//NSString *urlAddress = @"http://mobil.immobilienscout24.de/expose/";
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
    [urlAddress release];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
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

-(IBAction)takeOver{
     
    FlatTakeOverTask *flatTask = [[FlatTakeOverTask alloc]init];
    [flatTask takeOverFlat:[self selectedExposeId]];
    
}
@end
