//
//  FlatRemoveTask.m
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 26.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FlatRemoveTask.h"
#import "HistoryEntry.h"
#import "JSONParser.h"
#import "ImmopolyManager.h"
#import "Constants.h"

@implementation FlatRemoveTask

@synthesize selectedPortfoliotFlat;
@synthesize data;
@synthesize connection;


- (void)removeFlat:(Flat *)_selectedPortfoliotFlat {

    [self setSelectedPortfoliotFlat:_selectedPortfoliotFlat];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"userToken"] != nil) {
        //get user token
        NSString *userToken = [defaults objectForKey:@"userToken"];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@remove?token=%@&expose=%d",urlImmopolyPortfolio ,userToken, [[self selectedPortfoliotFlat] exposeId]]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
        
        [self setConnection: [NSURLConnection connectionWithRequest:request delegate:self]];
        
        
        if ([self connection]) {
            self.data = [NSMutableData data];
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
    NSError *err=nil;
    HistoryEntry *resultHistEntry = [JSONParser parseHistoryEntry:jsonString :&err];
    
    if (err) {
        //Handle Error here
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:err forKey:@"error"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"portfolio/add fail" object:nil userInfo:errorInfo];
    }else{
        if (resultHistEntry) {
            ImmopolyUser *user = [[ImmopolyManager instance]user];
            
            //add history
            [[user history]insertObject:resultHistEntry atIndex:0];
            
            // set new balance 
            [user setBalance:[user balance]+[resultHistEntry amount]];
            
            //send notification
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:resultHistEntry forKey:@"histEntry"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"portfolio/remove" object:nil userInfo:userInfo];    
        }
    }
}

@end
