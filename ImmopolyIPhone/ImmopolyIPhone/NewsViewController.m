//
//  NewsViewController.m
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 09.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsViewController.h"

@implementation NewsViewController
@synthesize newsList;

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
    
  //  NSString *urlAddress = [[NSString alloc]initWithFormat:@"%@%i",urlIS24MobileExpose,[selectedImmoscoutFlat exposeId]];
    
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:@"http://immopoly.org/frameless-news.html"];
    //[urlAddress release];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[newsList loadRequest:requestObj];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[super spinner] startAnimating];    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[super spinner] stopAnimating];    
    [[super spinner] setHidden:YES];
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

@end
