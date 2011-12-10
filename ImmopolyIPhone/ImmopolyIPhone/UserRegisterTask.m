//
//  UserRegisterTask.m
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 17.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UserRegisterTask.h"
#import "ImmopolyManager.h"
#import "JSONParser.h"
#import "Constants.h"

@implementation UserRegisterTask
@synthesize data, connection, delegate;

- (void)performRegistration:(NSString *)_userName withPassword:(NSString *)_password withEmail:(NSString *)_email withTwitter:(NSString *)_twitter {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@register?username=%@&password=%@&email=%@&twitter=%@",urlImmopolyUser,_userName, _password, _email, _twitter]];
    
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"user/register fail" object:nil userInfo:errorInfo];
        [delegate registerWithResult: NO];
    }else{
        [delegate registerWithResult: YES];
    }
    [jsonString release];
}

@end
