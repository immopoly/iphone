//
//  PortfolioTask.m
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 07.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PortfolioTask.h"
#import "Constants.h"
#import "ImmopolyManager.h"
#import "JSONParser.h"


@implementation PortfolioTask
@synthesize delegate;
@synthesize connection;
@synthesize data;

- (void)refreshPortolio{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@&start=0&end=30",urlImmopolyExpose,[[[ImmopolyManager instance]user]userToken]]];
    
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
    [[[ImmopolyManager instance]user]setPortfolio:[JSONParser parseExposes:jsonString :&err]];
 
    
    if (err) {
        //Handle Error here
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:err forKey:@"error"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh/portfolio fail" object:nil userInfo:errorInfo];
        
    }else{
        [delegate notifyMyDelegateView];
    }
    
    [jsonString release];
}

@end
