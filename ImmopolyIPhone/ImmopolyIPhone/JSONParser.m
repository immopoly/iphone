//
//  JSONParser.m
//  ImmopolyPrototype
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JSONParser.h"
#import "SBJSON.h"
#import "ImmopolyUser.h"
#import "Flat.h"
#import "ImmopolyManager.h"
#import "HistoryEntry.h"

@implementation JSONParser

@synthesize delegate;

+ (void)parseUserData:(NSString *)jsonString{
    // Create a dictionary from the JSON string
    NSDictionary *results = [jsonString JSONValue];
    
    NSDictionary *user = [results objectForKey:@"org.immopoly.common.User"];
    
    ImmopolyUser *myUser = [[ImmopolyUser alloc]init];
    [myUser setUserName:[user objectForKey:@"username"]];
    [myUser setUserToken:[user objectForKey:@"token"]];
    
    //saving the token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[myUser userToken] forKey:@"userToken"];
    [defaults synchronize];
    
    [myUser setEmail:[user objectForKey:@"email"]];
    
    NSDictionary *info = [user objectForKey:@"info"];
    
    //parse history
    NSArray *historyList = [info objectForKey:@"historyList"];
    for (NSDictionary *listElement in historyList) {
        NSDictionary *listEntry = [listElement objectForKey:@"org.immopoly.common.History"];
        
        HistoryEntry *userHistoryEntry = [[HistoryEntry alloc] init];
        
        [userHistoryEntry setHistText: [listEntry objectForKey: @"text"]];
        [userHistoryEntry setTime: [[listEntry objectForKey: @"time"] doubleValue]];
        [userHistoryEntry setType: [[listEntry objectForKey: @"type"] intValue]];
        [userHistoryEntry setType2: [[listEntry objectForKey:@"type2"] intValue]];
        
        [myUser.history addObject: userHistoryEntry];
        
        [userHistoryEntry release];
    }    
    
    //parse user balance, lastRent and lastProvision
    [myUser setLastRent:[[info objectForKey:@"lastRent"] doubleValue]];
    [myUser setBalance:[[info objectForKey:@"balance"] doubleValue]];
    [myUser setLastProvision: [[info objectForKey:@"lastProvision"] doubleValue]];

    //parse data for user portfolio
    NSDictionary *locationDict = [info objectForKey:@"resultlist.resultlist"];
    
    NSMutableArray *locations = [locationDict objectForKey:@"resultlistEntries"];
    NSMutableArray *entries = [locations objectAtIndex:0];
    
    for (NSDictionary *location in entries) {
        NSDictionary *flat = [location objectForKey:@"expose.expose"];
        NSDictionary *realEstate = [flat objectForKey:@"realEstate"];
        
        Flat *myFlat = [[Flat alloc] init];
        //parse realEstate
        [myFlat setName: [realEstate objectForKey:@"title"]];
        [myFlat setPriceValue: [realEstate objectForKey:@"baseRent"]];
        [myFlat setUid: [[realEstate objectForKey:@"@id"] intValue]];
        
        NSDictionary *address = [realEstate objectForKey:@"address"];
        NSDictionary *coordinate = [address objectForKey: @"wgs84Coordinate"];
        [myFlat setLat: [[coordinate objectForKey:@"latitude"] doubleValue]];
        [myFlat setLng: [[coordinate objectForKey:@"longitude"] doubleValue]];
        
        //save flats to user portfolio
        [myUser.portfolio addObject: myFlat];
        
        [myFlat release];
    }

    
    [[ImmopolyManager instance] setUser:myUser];
    
    
    //test portfolio and history parser
    /*
    NSLog(@"Portfolioeinträge: %i", [[ImmopolyManager instance].user.portfolio count]);
    for (Flat *flat in [ImmopolyManager instance].user.portfolio) {
        NSLog(@"%i - %@ - %f - %f - %@", flat.uid, flat.name, flat.lat, flat.lng, flat.priceValue);
    }
    NSLog(@"History Einträge: %i", [[ImmopolyManager instance].user.history count]);
    for (HistoryEntry *h in [ImmopolyManager instance].user.history) {
        NSLog(@"%@ - %f - %i - %i", h.histText, h.time, h.type, h.type2);
    }
    */
}

+ (void)parseFlatData:(NSString *)jsonString{
    NSDictionary *results = [jsonString JSONValue];
    
    NSDictionary *resultList = [results objectForKey:@"resultlist.resultlist"];
    
    //TODO: check 
    NSDictionary *resultlistEntries = [resultList objectForKey:@"resultlistEntries"];
    
    //TODO: check 
    NSMutableArray *resultEntry = [[resultlistEntries objectAtIndex:0] objectForKey:@"resultlistEntry"];
    
    
    //TODO: check 
    for (NSDictionary *entry in resultEntry){
        
        Flat *myFlat = [[Flat alloc] init];
        
        // general
        [myFlat setUid:[[entry objectForKey:@"realEstateId"] intValue]];
        NSDictionary *realEstate = [entry objectForKey:@"resultlist.realEstate"];
        [myFlat setName:[realEstate objectForKey:@"title"]];
        [myFlat setDescription:[realEstate objectForKey:@"descriptionNote"]];
        [myFlat setLocationNode:[realEstate objectForKey:@"locationNote"]];
        
        // adress fields
        NSDictionary *address = [realEstate objectForKey:@"address"];
        [myFlat setCity:[address objectForKey:@"city"]];
        [myFlat setPostcode:[address objectForKey:@"postcode"]];
        [myFlat setStreet:[address objectForKey:@"street"]];
        [myFlat setHouseNumber:[[address objectForKey:@"houseNumber"] intValue]];
        [myFlat setQuater:[address objectForKey:@"quater"]];
        
        // coordinates
        if([address objectForKey:@"wgs84Coordinate"] != nil){
            NSDictionary *coordinate = [address objectForKey:@"wgs84Coordinate"];
            [myFlat setLat:[[coordinate objectForKey:@"latitude"] doubleValue]];
            [myFlat setLng:[[coordinate objectForKey:@"longitude"] doubleValue]];
        }
        
        [[[ImmopolyManager instance]ImmoScoutFlats]addObject:myFlat];
        [myFlat release];
        //add flat to flats or Flat initWithJSON at the beginning
    }
    
    NSLog(@"done");
    
    [[ImmopolyManager instance] callFlatsDelegate];
    
}

+ (void)parseHistoryEntry:(NSString *)jsonString:(NSError **) err{
    NSDictionary *results = [jsonString JSONValue];
    
    if ([jsonString rangeOfString:@"ImmopolyException"].location != NSNotFound) {
        NSLog(@"Exception");
        
        NSDictionary *exceptionDic = [results objectForKey:@"org.immopoly.common.ImmopolyException"];
        NSString *exceptionMessage = [exceptionDic objectForKey:@"message"];
        int errorCode = [[exceptionDic objectForKey:@"errorCode"]intValue];
        
        *err = [NSError errorWithDomain:@"parseHistory" code:errorCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:exceptionMessage],@"ErrorMessage",nil]];
      
        
    } else {
        NSDictionary *histDic = [results objectForKey:@"org.immopoly.common.History"];
        
        HistoryEntry *histEntry = [[HistoryEntry alloc]init];
        [histEntry setHistText:[histDic objectForKey:@"text"]];
        [histEntry setTime:[[histDic objectForKey:@"time"]doubleValue]];
        [histEntry setType:[[histDic objectForKey:@"type"]intValue]];
        [histEntry setType2:[[histDic objectForKey:@"type2"]intValue]];
        
        [[[[ImmopolyManager instance]user]history]addObject:histEntry];
        [histEntry release];
    }
    
    
    //Test
    *err = [NSError errorWithDomain:@"parseHistory" code:201 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Gehört dir schon"],@"ErrorMessage",nil]];
}

@end
