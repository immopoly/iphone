//
//  ImmopolyPrototypeViewController.m
//  ImmopolyPrototype
//
//  Created by Tobias Heine on 10.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImmopolyPrototypeViewController.h"
#import "JSON.h"
#import "User.h"

@implementation ImmopolyPrototypeViewController

@synthesize userName,password, connection, data,testVC;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [password setSecureTextEntry:YES];
    
}


-(void)dealloc{
    [super dealloc];
    [data release];
    [connection release];
    [testVC release];
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

- (IBAction) performLogin{
    if ([[userName text] length]> 0 && [[password text]length]>0) {
        //Check user login
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://immopoly.appspot.com/user/login?username=%@&password=%@",[userName text], [password text]]];
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

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Need more chars" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
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
        
    }
    
    // Create a dictionary from the JSON string
    NSDictionary *results = [jsonString JSONValue];
    
    if ([jsonString rangeOfString:@"org.immopoly.common.ImmopolyException"].location == NSNotFound) {

        NSLog(jsonString);
        
        NSDictionary *user = [results objectForKey:@"org.immopoly.common.User"];
        User *myUser = [[User alloc]init];
        [myUser setUserName:[user objectForKey:@"username"]];
        [myUser setToken:[user objectForKey:@"token"]];
        
        NSDictionary *info = [user objectForKey:@"info"];
        NSDictionary *locationDict = [info objectForKey:@"resultlist.resultlist"];
        
        NSMutableArray *locations = [locationDict objectForKey:@"resultlistEntries"];
        NSMutableArray *entries = [locations objectAtIndex:0];
        
        
        for (NSDictionary *location in entries) {
            NSDictionary *flat = [location objectForKey:@"expose.expose"];
            NSDictionary *realEstate = [flat objectForKey:@"realEstate"];
            NSLog(@"%@",[realEstate objectForKey:@"title"]);
            
            NSDictionary *address = [realEstate objectForKey:@"address"];
            
            NSLog(@"%@",[address objectForKey:@"latitude"]);
            NSLog(@"%@",[address objectForKey:@"longitude"]);
            
        }
        
        testVC = [[HTTPTestViewController alloc]init];
        [self.view addSubview:testVC.view];
        [jsonString release];
        
        
    } else {
        
        NSDictionary *exception = [results objectForKey:@"org.immopoly.common.ImmopolyException"];
        NSString *errorMsg = [exception objectForKey:@"message"];
            
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    
    
}

@end
