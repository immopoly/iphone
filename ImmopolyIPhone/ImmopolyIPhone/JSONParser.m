//
// JSONParser.m
// ImmopolyPrototype
//
// Created by Tobias Buchholz on 26.10.11.
// Copyright (c) 2011 __MyCompanyName__. All rights reserved.
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
        
        [[myUser history] addObject: userHistoryEntry];
        
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
        NSDictionary *address = [realEstate objectForKey:@"address"];
        NSDictionary *coordinate = [address objectForKey: @"wgs84Coordinate"];
        
        CLLocationCoordinate2D tempCoord = CLLocationCoordinate2DMake([[coordinate objectForKey:@"latitude"] doubleValue],[[coordinate objectForKey:@"longitude"] doubleValue]);
        
        Flat *myFlat = [[Flat alloc] initWithName:[realEstate objectForKey:@"title"] description:[realEstate objectForKey:@"descriptionNote"] coordinate:tempCoord exposeId:[[location objectForKey:@"realEstateId"] intValue]];
        
        //parse realEstate
        [myFlat setPriceValue: [realEstate objectForKey:@"baseRent"]];
        
        //save flats to user portfolio
        [[myUser portfolio] addObject: myFlat];
        
        [myFlat release];
    }
    
    
    [[ImmopolyManager instance] setUser: myUser];
    
    
    //test portfolio and history parser
    /*
     NSLog(@"Portfolioeinträge: %i", [[[[ImmopolyManager instance] user] portfolio] count]);
     for (Flat *flat in [[[ImmopolyManager instance] user] portfolio]) {
         NSLog(@"%i - %@ - %@", [flat exposeId], [flat name], [flat priceValue]);
     }
     NSLog(@"History Einträge: %i", [[[[ImmopolyManager instance] user] history] count]);
        for (HistoryEntry *h in [[[ImmopolyManager instance] user] history]) {
     NSLog(@"%@ - %f - %i - %i", [h histText], [h time], [h type], [h type2]);
     }
    */
}

+ (void)parseFlatData:(NSString *)jsonString{
    NSLog(@"parseFlatData");
    NSDictionary *results = [jsonString JSONValue];
    
    NSDictionary *resultList = [results objectForKey:@"resultlist.resultlist"];
    
    //TODO: check
    NSDictionary *resultlistEntries = [resultList objectForKey:@"resultlistEntries"];
    
    //TODO: check
    NSMutableArray *resultEntry = [[resultlistEntries objectAtIndex:0] objectForKey:@"resultlistEntry"];
    
    
    //TODO: check
    for (NSDictionary *entry in resultEntry){
        
        NSDictionary *realEstate = [entry objectForKey:@"resultlist.realEstate"];
        NSDictionary *address = [realEstate objectForKey:@"address"];
        NSDictionary *price = [realEstate objectForKey:@"price"];
        
        // coordinates
        if([address objectForKey:@"wgs84Coordinate"] != nil){
            NSDictionary *coordinate = [address objectForKey:@"wgs84Coordinate"];
        
            CLLocationCoordinate2D tempCoord = CLLocationCoordinate2DMake([[coordinate objectForKey:@"latitude"] doubleValue],[[coordinate objectForKey:@"longitude"] doubleValue]);
        
            Flat *myFlat = [[Flat alloc] initWithName:[realEstate objectForKey:@"title"] description:[realEstate objectForKey:@"descriptionNote"] coordinate:tempCoord exposeId:[[entry objectForKey:@"realEstateId"] intValue]];
            
            // add other information to flat 
            [myFlat setLocationNode:[realEstate objectForKey:@"locationNote"]];
            
            // adress fields        
            [myFlat setCity:[address objectForKey:@"city"]];
            [myFlat setPostcode:[address objectForKey:@"postcode"]];
            [myFlat setStreet:[address objectForKey:@"street"]];
            [myFlat setHouseNumber:[[address objectForKey:@"houseNumber"] intValue]];
            [myFlat setQuarter:[address objectForKey:@"quarter"]];
            [myFlat setPrice:[[price objectForKey:@"value"] doubleValue]];
            [myFlat setNumberOfRooms:[[realEstate objectForKey:@"numberOfRooms"] intValue]];
            [myFlat setLivingSpace:[[realEstate objectForKey:@"livingSpace"] doubleValue]];
            
            //add flat to flats or Flat initWithJSON at the beginning
            [[[ImmopolyManager instance]ImmoScoutFlats]addObject:myFlat];
            [myFlat release];
        }
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

