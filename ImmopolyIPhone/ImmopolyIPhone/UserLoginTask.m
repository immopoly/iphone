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
#import "Constants.h"
#import "AppDelegate.h"

@implementation UserLoginTask

@synthesize connection;
@synthesize data;
@synthesize delegate; 


// TODO: releasing url and request (not possible?)
- (void)performLogin:(NSString *)_userName password:(NSString *)_password {
    
    NSString *urlString = [NSString stringWithFormat:@"%@login?username=%@&password=%@",urlImmopolyUser,_userName, _password];
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    
    [self setConnection: [NSURLConnection connectionWithRequest:request delegate:self]];
    
    
    if ([self connection]) {
        self.data = [NSMutableData data];
    }
}

// TODO: releasing url and request (not possible?)
- (void)performLoginWithToken:(NSString *)_userToken {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@info?token=%@",urlImmopolyUser,_userToken]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    [self setConnection: [NSURLConnection connectionWithRequest:request delegate:self]];
    
    
    if ([self connection]) {
        self.data = [NSMutableData data];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [[self data] appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)d {
    NSLog(@"didFailWithError");
    [delegate loginWithResult: NO];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
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
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [[appDelegate actionItemManager]placeActionItems];
    }
    
}

@end
