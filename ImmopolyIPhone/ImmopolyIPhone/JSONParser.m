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
    NSDictionary *historyList = [info objectForKey:@"historyList"];
    //TODO: parse history
    
    [myUser setLastRent:[[info objectForKey:@"lastRent"] doubleValue]];
    [myUser setBalance:[[info objectForKey:@"balance"] doubleValue]]; 

   
    //
    NSDictionary *locationDict = [info objectForKey:@"resultlist.resultlist"];
    
    NSMutableArray *locations = [locationDict objectForKey:@"resultlistEntries"];
    NSMutableArray *entries = [locations objectAtIndex:0];
    
    
    for (NSDictionary *location in entries) {
        NSDictionary *flat = [location objectForKey:@"expose.expose"];
        NSDictionary *realEstate = [flat objectForKey:@"realEstate"];
        NSLog(@"%@",[realEstate objectForKey:@"title"]);
        
        //TODO: parse realEstate
        
        NSDictionary *address = [realEstate objectForKey:@"address"];
        
        NSLog(@"%@",[address objectForKey:@"latitude"]);
        NSLog(@"%@",[address objectForKey:@"longitude"]);
        
    }

    [[ImmopolyManager instance] setUser:myUser];
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
    [[ImmopolyManager instance]callFlatsDelegate];
    
}

@end
