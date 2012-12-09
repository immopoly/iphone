//
//  FlatProvider.m
//  libOAuthDemo
//
//  Created by Tobias Heine on 26.10.11.
//  Copyright (c) 2011 Immobilienscout24. All rights reserved.
//

#import "FlatProvider.h"
#import "OAuthManager.h"
#import "JSONParser.h"
#import "ImmopolyManager.h"
#import "Constants.h"
#import "SBJSON.h"

@implementation FlatProvider

@synthesize location, pageNum, idxRadius, maxRadiusReached;

- (void)getExposeFromId:(int)_exposeId {
    OAuthManager *manager = [[OAuthManager alloc] init];
    
    NSString *url = [[NSString alloc]initWithFormat:@"%@expose/%d",urlIS24API,_exposeId];
    
    [manager grabURLInBackground:url withFormat:@"application/json" withDelegate:self];
}


- (void)getFlatsFromLocation:(CLLocationCoordinate2D)_location {
    pageNum = 1;
    idxRadius = 0;
    [self setLocation:_location];
    
    [self getFlatsFromLocationAndPageNumber:pageNum andRadius:SEARCH_RADII[idxRadius]];
    
    [[ImmopolyManager instance]showFlatSpinner];
    
    
}

- (void)getFlatsFromLocationAndPageNumber:(int)_pageNumber andRadius:(int)_radius{
    OAuthManager *manager = [[OAuthManager alloc] init];
    
    NSString *url = [[NSString alloc]initWithFormat:@"%@search/radius.json?realEstateType=apartmentrent&pagenumber=%d&geocoordinates=%f;%f;%d",urlIS24API, pageNum, self.location.latitude, self.location.longitude, _radius];
    
    [manager grabURLInBackground:url withFormat:@"application/json" withDelegate:self];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString *responseString = [request responseString];
    NSError *err = nil;
    NSArray *flats = nil;
    BOOL shouldCall = NO; 
    
    NSDictionary *results = [responseString JSONValue];
    NSDictionary *resultList = [results objectForKey:@"resultlist.resultlist"];
    NSDictionary *pagingInfo = [resultList objectForKey:@"paging"];
    int numPages = [[pagingInfo objectForKey:@"numberOfPages"] doubleValue];
    int numHits = [[pagingInfo objectForKey:@"numberOfHits"] doubleValue];
    pageNum = [[pagingInfo objectForKey:@"pageNumber"] doubleValue];
    
    if (numPages > 5) {
        numPages = 5;
    } 
    
    if(!maxRadiusReached){
        if (numHits < SEARCH_MIN_RESULTS) {            
            if(idxRadius < 2) {
                // increase radius, because not enough hits
                idxRadius++;
                [self getFlatsFromLocationAndPageNumber:pageNum andRadius:SEARCH_RADII[idxRadius]];    
            } else {
                maxRadiusReached = YES;
                [self getFlatsFromLocationAndPageNumber:pageNum andRadius:SEARCH_RADII[idxRadius]];    
            }
        } else {
            // enough hits, so trying to get more flats from another pages
            flats = [JSONParser parseFlatData:responseString :&err];
            pageNum++;
            if(pageNum < numPages) {
                [self getFlatsFromLocationAndPageNumber:pageNum andRadius:SEARCH_RADII[idxRadius]];
            } else {
                shouldCall = YES;
            }
        }    
    } else {
        // max. radius is reached, so trying to get more flats from another pages
        flats = [JSONParser parseFlatData:responseString :&err];
        pageNum++;
        if(pageNum < numPages) {
            [self getFlatsFromLocationAndPageNumber:pageNum andRadius:SEARCH_RADII[idxRadius]];    
        } else {
            shouldCall = YES;
        }
    }
    
    if (err) {
        //Handle Error here
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:err forKey:@"error"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"flatProvider/parse fail" object:nil userInfo:errorInfo];
    }else{
       [[[ImmopolyManager instance] immoScoutFlats] addObjectsFromArray:flats];
        if(([flats count] > SEARCH_MIN_RESULTS && [flats count] < SEARCH_MAX_RESULTS) || shouldCall) {
            [[ImmopolyManager instance] callFlatsDelegate];    
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];

    NSLog(@"Error: %@",[error localizedDescription]);
}

@end
