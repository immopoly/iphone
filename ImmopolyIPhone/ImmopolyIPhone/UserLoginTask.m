//
//  DataLoader.m
//  ImmopolyPrototype
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UserLoginTask.h"
#import "JSONParser.h"
#import "ImmopolyManager.h"

@implementation UserLoginTask

@synthesize connection, data, delegate; 

-(void)dealloc{
    [connection release];
    [data release];
}

// TODO: releasing url and request (not possible?)
- (void)performLogin:(NSString *)_userName password:(NSString *)_password {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://immopoly.appspot.com/user/login?username=%@&password=%@",_userName, _password]];
   
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    [self setConnection: [NSURLConnection connectionWithRequest:request delegate:self]];
    
    
    if ([self connection]) {
        [self setData: [[NSMutableData data] retain]];
    }
}

// TODO: releasing url and request (not possible?)
- (void)performLoginWithToken:(NSString *)_userToken {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://immopoly.appspot.com/user/info?token=%@", _userToken]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    [self setConnection: [NSURLConnection connectionWithRequest:request delegate:self]];
    
    
    if ([self connection]) {
        [self setData: [[NSMutableData data] retain]];
    }
}

- (void)connection:(NSURLConnection *)_connection didReceiveData:(NSData *)_data {
    [[self data] appendData:_data];
}

- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)_error {
    NSLog(@"didFailWithError");
    [delegate loginWithResult: NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)_connection {
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([jsonString isEqualToString:@""]) {
        NSLog(@"jsonString is empty");
    }
    
    NSError *err=nil;
    [[ImmopolyManager instance] setUser:[JSONParser parseUserData:jsonString :&err]];
    
    if (err) {
        //Handle Error here
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:err forKey:@"error"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"user/login fail" object:nil userInfo:errorInfo];
        [delegate loginWithResult:NO];
    }else{
        [[ImmopolyManager instance] setLoginSuccessful:YES];
        [delegate loginWithResult: YES];
    }
    
    [jsonString release];
}

@end
