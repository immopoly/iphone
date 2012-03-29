//
//  SpionAction.m
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 28.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpionAction.h"
#import "Constants.h"
#import "ImmopolyManager.h"
#import "SBJSON.h"
#import "Flat.h"

@implementation SpionAction

@synthesize data;
@synthesize connection;
@synthesize delegate;
- (void)executeAction:(NSMutableArray *)_exposes{
    
    NSMutableString *exposesList = [[NSMutableString alloc]initWithString:@"["];
    
    NSMutableArray *_exposeIds = [[NSMutableArray alloc]init];
    for (Flat *object in _exposes) {
        [_exposeIds addObject:[NSNumber numberWithInt:[object exposeId]]];
    }
    
    for (int i=0; i<[_exposeIds count]; i++) {
        NSNumber *exposeId = [_exposeIds objectAtIndex:i];
        [exposesList appendString:[[NSString alloc]initWithFormat:@"%d",[exposeId intValue]]];
        
        if (i<[_exposeIds count]-1) {
            [exposesList appendString:@","];
        }
        
    }
    
    [exposesList  appendString:@"]"];
  
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@action",urlImmopolyUser]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    
    
    NSString *json = [[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"actiontype",_exposeIds,@"exposes",[[[ImmopolyManager instance]user]userToken],@"token", nil]JSONRepresentation];
    
    [request setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setConnection: [NSURLConnection connectionWithRequest:request delegate:self]];
    
    if ([self connection]) {
        [self setData: [[NSMutableData data] retain]];
    }
    
    [exposesList release];
    [_exposeIds release];
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
    [delegate executedActionWithResult:YES];
    
    
    NSMutableArray *freeExposeIds = [jsonString JSONValue];
    NSMutableArray *freeExposes = [[NSMutableArray alloc]init];
    
    //Delete other flats from portfolio
    
    for (Flat *object in [[ImmopolyManager instance]immoScoutFlats]) {
        if ([freeExposeIds containsObject:[NSNumber numberWithInt:[object exposeId]]]) {
            [freeExposes addObject:object];
        }
    }
    [[ImmopolyManager instance]setImmoScoutFlats:freeExposes]; 
    
    //Show free flats on Map
    [[ImmopolyManager instance] callFlatsDelegate];
    
    [freeExposes autorelease];
    
}


@end