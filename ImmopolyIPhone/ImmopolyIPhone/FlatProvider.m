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

#define NUMBER_OF_PAGES 4

@interface FlatProvider() {
    // counter variable for getting flats from location of 5 pages
    int pageNum; 
}

@end

@implementation FlatProvider


- (void)getExposeFromId:(int)_exposeId {
    OAuthManager *manager = [[OAuthManager alloc] init];
    
    NSString *url = [[NSString alloc]initWithFormat:@"%@expose/%d",urlIS24API,_exposeId];
    
    [manager grabURLInBackground:url withFormat:@"application/json" withDelegate:self];
    [manager release];
    [url release];
}


- (void)getFlatsFromLocation:(CLLocationCoordinate2D)_location {
    OAuthManager *manager = [[OAuthManager alloc] init];
    NSString *url; 
    
    for(pageNum=1; pageNum<=NUMBER_OF_PAGES; pageNum++) {
        url = [[NSString alloc]initWithFormat:@"%@search/radius.json?realEstateType=apartmentrent&pagenumber=%d&geocoordinates=%f;%f;3.0",urlIS24API, pageNum, _location.latitude, _location.longitude];
    
        [manager grabURLInBackground:url withFormat:@"application/json" withDelegate:self];
    }
    
    [manager release];
    [url release];
    pageNum=1;
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString *responseString = [request responseString];
    NSError *err=nil;
    [[[ImmopolyManager instance] immoScoutFlats] addObjectsFromArray:[JSONParser parseFlatData:responseString :&err]];
    
    if (err) {
        //Handle Error here
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:err forKey:@"error"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"flatProvider/parse fail" object:nil userInfo:errorInfo];
    }else{
        if(pageNum == NUMBER_OF_PAGES) {
            [[ImmopolyManager instance] callFlatsDelegate];
            NSLog(@"Response: %@",responseString);    
        }
    }
    pageNum++;
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];

    NSLog(@"Error: %@",[error localizedDescription]);
}

@end
