//
//  HTTPTestViewController.m
//  ImmopolyPrototype
//
//  Created by Tobias Heine on 11.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HTTPTestViewController.h"

@implementation HTTPTestViewController
@synthesize webAdress,jsonResponse,connection,data;

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

- (IBAction)performPost{
    NSLog([webAdress text]);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[webAdress text]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    [self setConnection: [NSURLConnection connectionWithRequest:request delegate:self]];
    NSLog(@"%@",[connection description]);
    
    if ([self connection]) {
        [self setData: [[NSMutableData data] retain]];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Login Error" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
	[[self data] appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Login Error" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([jsonString isEqualToString:@""]) {
        [jsonResponse setText:@"No values"];
    }else{
        [jsonResponse setText:jsonString];
        NSLog(jsonString);
    }
    
    // Create a dictionary from the JSON string
    NSDictionary *results = [jsonString JSONValue];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
    [webAdress resignFirstResponder];
    [jsonResponse resignFirstResponder];
}


@end
