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
#import "UserBadge.h"

@implementation JSONParser

@synthesize delegate;


+ (void)parsePublicUserData:(NSString *)jsonString:(NSError **)err{
    // Create a dictionary from the JSON string
    NSDictionary *results = [jsonString JSONValue];
    ImmopolyUser *myUser = [[[ImmopolyUser alloc] init] autorelease];
    
    if ([jsonString rangeOfString:@"ImmopolyException"].location != NSNotFound) {
        
        NSDictionary *exceptionDic = [results objectForKey:@"org.immopoly.common.ImmopolyException"];
        NSString *exceptionMessage = [exceptionDic objectForKey:@"message"];
        int errorCode = [[exceptionDic objectForKey:@"errorCode"]intValue];
        
        *err = [NSError errorWithDomain:@"parseUserData" code:errorCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:exceptionMessage],@"ErrorMessage",nil]];
    } 
    else {
        NSDictionary *user = [results objectForKey:@"org.immopoly.common.User"];
        
        [[ImmopolyManager instance] user].userName = [user objectForKey:@"username"];
        [[ImmopolyManager instance] user].email = [user objectForKey:@"email"];
        
       
        NSDictionary *info = [user objectForKey:@"info"];
        
        //parse user balance, lastRent and lastProvision
        [myUser setLastRent:[[info objectForKey:@"lastRent"] doubleValue]];
        [myUser setBalance:[[info objectForKey:@"balance"] doubleValue]];
        [myUser setLastProvision: [[info objectForKey:@"lastProvision"] intValue]];
        [myUser setNumExposes: [[info objectForKey:@"numExposes"] intValue]];
        [myUser setMaxExposes: [[info objectForKey:@"maxExposes"] intValue]];
        
        //parse Badges data
        NSArray *badgesDict = [info objectForKey:@"bagdesList"];
        for (NSDictionary *listElement in badgesDict) {
            NSDictionary *listEntry = [listElement objectForKey:@"Badge"];
            
            UserBadge *userBadge = [[UserBadge alloc] init];
            
            [userBadge setText: [listEntry objectForKey: @"text"]];
            [userBadge setTime: [[listEntry objectForKey: @"time"] longLongValue]];
            [userBadge setType: [[listEntry objectForKey: @"type"] intValue]];
            [userBadge setAmount: [[listEntry objectForKey:@"amount"] intValue]];
            [userBadge setUrl: [listEntry objectForKey:@"url"]];
            
            [[myUser badges] addObject: userBadge];
            
            [userBadge release];
        }
    }
    
}

+ (ImmopolyUser *)parseUserData:(NSString *)jsonString:(NSError **)err{
    // Create a dictionary from the JSON string
    NSDictionary *results = [jsonString JSONValue];
    ImmopolyUser *myUser = [[[ImmopolyUser alloc] init] autorelease];
    
    if ([jsonString rangeOfString:@"ImmopolyException"].location != NSNotFound) {
        
        NSDictionary *exceptionDic = [results objectForKey:@"org.immopoly.common.ImmopolyException"];
        NSString *exceptionMessage = [exceptionDic objectForKey:@"message"];
        int errorCode = [[exceptionDic objectForKey:@"errorCode"]intValue];
        
        *err = [NSError errorWithDomain:@"parseUserData" code:errorCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:exceptionMessage],@"ErrorMessage",nil]];

        return nil;
    } 
    else {
        NSDictionary *user = [results objectForKey:@"org.immopoly.common.User"];
        
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
            [userHistoryEntry setOtherUserName: [listEntry objectForKey: @"otherUsername"]];
            [userHistoryEntry setTime: [[listEntry objectForKey: @"time"] longLongValue]];
            [userHistoryEntry setType: [[listEntry objectForKey: @"type"] intValue]];
            [userHistoryEntry setType2: [[listEntry objectForKey:@"type2"] intValue]];
            [userHistoryEntry setExposeId:[[listEntry objectForKey:@"exposeId"]intValue]];
            
            [[myUser history] addObject: userHistoryEntry];
            
            [userHistoryEntry release];
        }
        
        //parse user balance, lastRent and lastProvision
        [myUser setLastRent:[[info objectForKey:@"lastRent"] doubleValue]];
        [myUser setBalance:[[info objectForKey:@"balance"] doubleValue]];
        [myUser setLastProvision: [[info objectForKey:@"lastProvision"] intValue]];
        [myUser setNumExposes: [[info objectForKey:@"numExposes"] intValue]];
        [myUser setMaxExposes: [[info objectForKey:@"maxExposes"] intValue]];
        
        //parse Badges data
        NSArray *badgesDict = [info objectForKey:@"bagdesList"];
        for (NSDictionary *listElement in badgesDict) {
            NSDictionary *listEntry = [listElement objectForKey:@"Badge"];
            
            UserBadge *userBadge = [[UserBadge alloc] init];
            
            [userBadge setText: [listEntry objectForKey: @"text"]];
            [userBadge setTime: [[listEntry objectForKey: @"time"] longLongValue]];
            [userBadge setType: [[listEntry objectForKey: @"type"] intValue]];
            [userBadge setAmount: [[listEntry objectForKey:@"amount"] intValue]];
            [userBadge setUrl: [listEntry objectForKey:@"url"]];
            
            [[myUser badges] addObject: userBadge];
            
            [userBadge release];
        }
        
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
            
            //create a Flat object
            Flat *myFlat = [[Flat alloc] initWithName:[realEstate objectForKey:@"title"] description:[realEstate objectForKey:@"descriptionNote"] coordinate:tempCoord exposeId:[[location objectForKey:@"realEstateId"] intValue]];
            
            //save Flat info
            [myFlat setExposeId:[[realEstate objectForKey:@"@id"]intValue]];
            [myFlat setNumberOfRooms: [[realEstate objectForKey: @"numberOfRooms"] intValue]];
            [myFlat setLivingSpace: [[realEstate objectForKey: @"livingSpace"] doubleValue]];
            [myFlat setPrice: [[realEstate objectForKey:@"baseRent"] doubleValue]];
            [myFlat setOvertakeDate:[[realEstate objectForKey:@"overtakeDate"] longLongValue]];
            
            //parse and save Flat title picture url
            NSDictionary *titlePicture = [realEstate objectForKey: @"titlePicture"];
            NSMutableArray *urls = [titlePicture objectForKey: @"urls"];
            NSDictionary *urlObject = [urls objectAtIndex: 0];
            NSDictionary *url = [urlObject objectForKey: @"url"];
            [myFlat setPictureUrl: [url objectForKey: @"@href"]];
            
            //save flats to user portfolio
            [[myUser portfolio] addObject: myFlat];
            
            [myFlat release];
        }
    }
    
    return myUser;
}

+ (NSArray *)parseHistoryEntries:(NSString *)jsonString:(NSError **)err{
    NSMutableArray *histEntries = [[[NSMutableArray alloc] init] autorelease];
    
    NSDictionary *results = [jsonString JSONValue];
    
    if ([jsonString rangeOfString:@"ImmopolyException"].location != NSNotFound) {
        
        NSDictionary *exceptionDic = [results objectForKey:@"org.immopoly.common.ImmopolyException"];
        NSString *exceptionMessage = [exceptionDic objectForKey:@"message"];
        int errorCode = [[exceptionDic objectForKey:@"errorCode"]intValue];
        
        *err = [NSError errorWithDomain:@"parseHistoryEntries" code:errorCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:exceptionMessage],@"ErrorMessage",nil]];
        
        return nil;
    } 
    else {
        for (NSDictionary *dictionary in results) {
            NSDictionary *histDic = [dictionary objectForKey:@"org.immopoly.common.History"];
            
            HistoryEntry *histEntry = [[[HistoryEntry alloc] init] autorelease];
            [histEntry setHistText:[histDic objectForKey:@"text"]];
            [histEntry setOtherUserName: [histDic objectForKey: @"otherUsername"]];
            [histEntry setTime:[[histDic objectForKey:@"time"]longLongValue]];
            [histEntry setType:[[histDic objectForKey:@"type"]intValue]];
            [histEntry setType2:[[histDic objectForKey:@"type2"]intValue]];
            [histEntry setExposeId:[[histDic objectForKey:@"exposeId"]intValue]];
            [histEntries addObject:histEntry];
        }
    }
    
    return histEntries;
}

+ (NSMutableArray *)parseExposes:(NSString *)jsonString:(NSError **)err{
    NSMutableArray *exposes = [[[NSMutableArray alloc] init] autorelease];
    
    NSDictionary *results = [jsonString JSONValue];
    
    
    if ([jsonString rangeOfString:@"ImmopolyException"].location != NSNotFound) {
        
        NSDictionary *exceptionDic = [results objectForKey:@"org.immopoly.common.ImmopolyException"];
        NSString *exceptionMessage = [exceptionDic objectForKey:@"message"];
        int errorCode = [[exceptionDic objectForKey:@"errorCode"]intValue];
        
        *err = [NSError errorWithDomain:@"parseExposes" code:errorCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:exceptionMessage],@"ErrorMessage",nil]];
        
        return nil;
    } 
    else {
        for (NSDictionary *dictionary in results) {
            NSDictionary *flat = [dictionary objectForKey:@"expose.expose"];
            NSDictionary *realEstate = [flat objectForKey:@"realEstate"];
            NSDictionary *address = [realEstate objectForKey:@"address"];
            NSDictionary *coordinate = [address objectForKey: @"wgs84Coordinate"];
            
            CLLocationCoordinate2D tempCoord = CLLocationCoordinate2DMake([[coordinate objectForKey:@"latitude"] doubleValue],[[coordinate objectForKey:@"longitude"] doubleValue]);
            
            //create a Flat object
            Flat *myFlat = [[Flat alloc] initWithName:[realEstate objectForKey:@"title"] description:[realEstate objectForKey:@"descriptionNote"] coordinate:tempCoord exposeId:[[dictionary objectForKey:@"realEstateId"] intValue]];
            
            //save Flat info
            [myFlat setExposeId:[[realEstate objectForKey:@"@id"]intValue]];
            [myFlat setNumberOfRooms: [[realEstate objectForKey: @"numberOfRooms"] intValue]];
            [myFlat setLivingSpace: [[realEstate objectForKey: @"livingSpace"] doubleValue]];
            [myFlat setPrice: [[realEstate objectForKey:@"baseRent"] doubleValue]];
            
            //parse and save Flat title picture url
            NSDictionary *titlePicture = [realEstate objectForKey: @"titlePicture"];
            NSMutableArray *urls = [titlePicture objectForKey: @"urls"];
            NSDictionary *urlObject = [urls objectAtIndex: 0];
            NSDictionary *url = [urlObject objectForKey: @"url"];
            [myFlat setPictureUrl: [url objectForKey: @"@href"]];
            
            [exposes addObject:myFlat];
            
            [myFlat release];        }
    }
    
    return exposes;
    
    

}

+ (NSMutableArray *)parseFlatData:(NSString *)jsonString:(NSError **)err{

    NSDictionary *results = [jsonString JSONValue];
    NSMutableArray *immoScoutFlats = [[[NSMutableArray alloc] init] autorelease];
    
    if ([jsonString rangeOfString:@"ImmopolyException"].location != NSNotFound) {
        
        NSDictionary *exceptionDic = [results objectForKey:@"org.immopoly.common.ImmopolyException"];
        //NSDictionary *exceptionMsg = [exceptionDic objectForKey:@"message"];
        NSString *exceptionMessage = [exceptionDic objectForKey:@"message"];
        int errorCode = [[exceptionDic objectForKey:@"errorCode"]intValue];
        
        *err = [NSError errorWithDomain:@"parseFlatData" code:errorCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:exceptionMessage],@"ErrorMessage",nil]];
        
        return nil;
    } 
    else {
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
                
                // picture
                NSDictionary *pictureInfo = [realEstate objectForKey:@"titlePicture"];
                [myFlat setPictureUrl:[pictureInfo objectForKey:@"@xlink.href"]];
                
                //add flat to flats 
                [immoScoutFlats addObject:myFlat];
                [myFlat release];
            }
        }
    }
    NSLog(@"done");
    return immoScoutFlats;
}

+ (HistoryEntry *)parseHistoryEntry:(NSString *)jsonString:(NSError **)err{
    NSDictionary *results = [jsonString JSONValue];
    
    if ([jsonString rangeOfString:@"ImmopolyException"].location != NSNotFound) {
        
        NSDictionary *exceptionDic = [results objectForKey:@"org.immopoly.common.ImmopolyException"];
        NSString *exceptionMessage = [exceptionDic objectForKey:@"message"];
        int errorCode = [[exceptionDic objectForKey:@"errorCode"]intValue];
        
        *err = [NSError errorWithDomain:@"parseHistory" code:errorCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:exceptionMessage],@"ErrorMessage",nil]];
        
        return nil;
    } 
    else {
        NSDictionary *histDic = [results objectForKey:@"org.immopoly.common.History"];
        
        HistoryEntry *histEntry = [[[HistoryEntry alloc] init] autorelease];
        [histEntry setHistText:[histDic objectForKey:@"text"]];
        [histEntry setTime:[[histDic objectForKey:@"time"]longLongValue]];
        [histEntry setType:[[histDic objectForKey:@"type"]intValue]];
        [histEntry setType2:[[histDic objectForKey:@"type2"]intValue]];
        [histEntry setExposeId:[[histDic objectForKey:@"exposeId"]intValue]];
        [histEntry setAmount:[[histDic objectForKey:@"amount"]doubleValue]];
        
        return  histEntry;
    }
}


@end

