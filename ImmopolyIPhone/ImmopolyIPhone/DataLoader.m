//
//  DataLoader.m
//  ImmopolyPrototype
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DataLoader.h"
#import "JSONParser.h"
#import "ImmopolyManager.h"

@implementation DataLoader

@synthesize connection, data, delegate; 

- (void)performLogin:(NSString *)userName password:(NSString *)password {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://immopoly.appspot.com/user/login?username=%@&password=%@",userName, password]];
   
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    [self setConnection: [NSURLConnection connectionWithRequest:request delegate:self]];
    
    
    if ([self connection]) {
        [self setData: [[NSMutableData data] retain]];
    }
    
}

- (void)performLoginWithToken:(NSString *) userToken {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://immopoly.appspot.com/user/info?token=%@", userToken]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    [self setConnection: [NSURLConnection connectionWithRequest:request delegate:self]];
    
    
    if ([self connection]) {
        [self setData: [[NSMutableData data] retain]];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [[self data] appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    [delegate loginWithResult: NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([jsonString isEqualToString:@""]) {
        NSLog(@"jsonString is empty");
    }
    
    [JSONParser parseUserData:jsonString];
    [[ImmopolyManager instance] setLoginSuccessful:YES];
    
    [delegate loginWithResult: YES];
    

}

@end
