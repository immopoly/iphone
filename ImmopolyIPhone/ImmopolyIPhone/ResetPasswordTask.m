//
//  ResetPasswordTask.m
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 18.12.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import "ResetPasswordTask.h"
#import "ImmopolyManager.h"
#import "JSONParser.h"
#import "Constants.h"

@implementation ResetPasswordTask

@synthesize connection;
@synthesize data;
@synthesize delegate;

-(void)dealloc {
    [connection release];
    [data release];
    [super dealloc];
}

-(void) performResetPasswordWithUsername:(NSString *)userName andEmail:(NSString *)email {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sendpasswordmail?username=%@&email=%@", urlImmopolyUser, userName, email]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    [self setConnection: [NSURLConnection connectionWithRequest:request delegate:self]];
    
    if ([self connection]) {
        self.data = [NSMutableData data];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"user/reset password fail" object:nil userInfo:errorInfo];
        [delegate resetPasswordWithResult: NO];
    }
    else {
        //Send success notification
        NSDictionary *taskInfo = [NSDictionary dictionaryWithObject:alertResetPasswordSuccessful forKey:@"message"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"user/reset password successful" object:nil userInfo:taskInfo];
        [delegate resetPasswordWithResult: YES];
    }
    
    [jsonString release];
}

@end
