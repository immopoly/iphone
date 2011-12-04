//
//  HistoryTask.m
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 04.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HistoryTask.h"
#import "ImmopolyManager.h"
#import "JSONParser.h"

@implementation HistoryTask
@synthesize data,connection,delegate,limit;

- (void)loadHistoryEintriesFrom:(int)start To :(int)end{
    
    limit = end - start;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://immopoly.appspot.com/user/history?token=%@&start=%d&end=%d",[[[ImmopolyManager instance]user]userToken],start, end]];
    
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
    //[delegate loginWithResult: NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([jsonString isEqualToString:@""]) {
        NSLog(@"jsonString is empty");
    }
    
    NSError *err=nil;

    NSArray *resultEntries = [[NSArray alloc]init];
    
    resultEntries = [JSONParser parseHistoryEntries:jsonString:&err];
    [[[[ImmopolyManager instance]user]history]addObjectsFromArray:resultEntries];
    
    if (err) {
        //Handle Error here
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:err forKey:@"error"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"user/history entries" object:nil userInfo:errorInfo];

    }else if([resultEntries count]< limit){
        //call delegate to tell table view what happened
        [delegate hasMoreData:NO];
    }else{
        [delegate hasMoreData:YES];
    }
}

@end
