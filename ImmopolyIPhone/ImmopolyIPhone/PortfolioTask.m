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
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@&start=%d&end=%d",urlIS24MobileExpose,[[[ImmopolyManager instance]user]userToken],0, 30]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    [self setConnection: [NSURLConnection connectionWithRequest:request delegate:self]];
    
    
    if ([self connection]) {
        [self setData: [[NSMutableData data] retain]];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([jsonString isEqualToString:@""]) {
        NSLog(@"jsonString is empty");
    }
    
    NSError *err=nil;
    [[[ImmopolyManager instance]user]setPortfolio:[JSONParser parseFlatData:jsonString :&err]];
 
    
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
