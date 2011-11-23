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

@implementation FlatProvider

-(void)getFlatsFromLocation:(CLLocationCoordinate2D)location{
    OAuthManager *manager = [[OAuthManager alloc] init];
    
    NSString *url = [[NSString alloc]initWithFormat:@"http://rest.immobilienscout24.de/restapi/api/search/v1.0/search/radius.json?realEstateType=apartmentrent&pagenumber=1&geocoordinates=%f;%f;3.0",location.latitude,location.longitude];
    
    [manager grabURLInBackground:url withFormat:@"application/json" withDelegate:self];
    [manager release];
    [url release];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSError *err=nil;
    [[ImmopolyManager instance] setImmoScoutFlats:[JSONParser parseFlatData:responseString :&err]]; 
    
    if (err) {
        //Handle Error here
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:err forKey:@"error"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"flatProvider/parse fail" object:nil userInfo:errorInfo];
    }else{
        [[ImmopolyManager instance] callFlatsDelegate];
        NSLog(@"Response: %@",responseString);
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];

    NSLog(@"Error: %@",[error localizedDescription]);
}

-(void)testMethod{

}
@end
