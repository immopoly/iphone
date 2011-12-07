//
//  FlatTakeOverTask.m
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 31.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FlatTakeOverTask.h"
#import "JSONParser.h"
#import "ImmopolyManager.h"
#import "Flat.h"

@implementation FlatTakeOverTask
@synthesize connection,data,selectedImmoscoutFlat;

-(void)takeOverFlat:(Flat *)_selectedImmoscoutFlat{
    [self setSelectedImmoscoutFlat:_selectedImmoscoutFlat];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"userToken"] != nil) {
        //get user token
        NSString *userToken = [defaults objectForKey:@"userToken"];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://immopoly.appspot.com/portfolio/add?token=%@&expose=%d",userToken, [[self selectedImmoscoutFlat] exposeId]]];
        
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
    NSError *err=nil;
    HistoryEntry *resultHistEntry = [JSONParser parseHistoryEntry:jsonString :&err];
    
    if (err) {
        //Handle Error here
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:err forKey:@"error"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"portfolio/add fail" object:nil userInfo:errorInfo];
    }else{
        if (resultHistEntry) {
            [[[[ImmopolyManager instance]user]history]insertObject:resultHistEntry atIndex:0];
            
            //when history has type 1 add expose to portfolio
            if([resultHistEntry type]==1){
                    [[[[ImmopolyManager instance]user]portfolio]insertObject:[self selectedImmoscoutFlat] atIndex:0];
            }
            
            //TODO: send Notification with history entry
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:resultHistEntry forKey:@"histEntry"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"portfolio/add" object:nil userInfo:userInfo];    
        }
    }
    
    [jsonString release];
}

@end
