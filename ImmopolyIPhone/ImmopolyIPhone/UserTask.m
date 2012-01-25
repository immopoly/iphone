//
//  UserTask.m
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 07.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserTask.h"
#import "ImmopolyManager.h"
#import "JSONParser.h"
#import "Constants.h"
#import "ImmopolyUser.h"

@implementation UserTask
@synthesize data;
@synthesize delegate;
@synthesize connection;

- (void)refreshUser:(NSString *)_userName{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@profile/%@.json",urlImmopolyUser,_userName]];
    
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
    ImmopolyUser *otherUser = [JSONParser parsePublicUserData:jsonString :&err];
    
    if (err) {
        //Handle Error here
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:err forKey:@"error"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"user/login fail" object:nil userInfo:errorInfo];
        
    }else{
        [delegate notifyMyDelegateViewWithUser:otherUser];
    }
    
    [jsonString release];
}


@end
