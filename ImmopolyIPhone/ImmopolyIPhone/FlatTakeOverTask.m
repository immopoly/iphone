//
//  FlatTakeOverTask.m
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 31.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FlatTakeOverTask.h"
#import "JSONParser.h"

@implementation FlatTakeOverTask
@synthesize connection,data;

-(void)takeOverFlat:(int)exposeId{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"userToken"] != nil) {
        //get user token
        NSString *userToken = [defaults objectForKey:@"userToken"];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://immopoly.appspot.com/portfolio/add?token=%@&expose=%d",userToken, exposeId]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
        
        [self setConnection: [NSURLConnection connectionWithRequest:request delegate:self]];
        
        
        if ([self connection]) {
            [self setData: [[NSMutableData data] retain]];
        }
    }else{
        //ToDo handle login
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
    
    [JSONParser parseHistoryEntry:jsonString];
}

@end
