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

@implementation FlatProvider

-(void)getFlatsFromLocation:(CLLocationCoordinate2D)location{
    OAuthManager *manager = [[OAuthManager alloc] init];
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://rest.immobilienscout24.de/restapi/api/search/v1.0/search/radius.json?realEstateType=apartmentrent&pagenumber=1&geocoordinates=%f;%f;3.0",location.latitude,location.longitude];
    
    NSString *url = urlString;
    
    [manager grabURLInBackground:url withFormat:@"application/json" withDelegate:self];
    [manager release];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    [JSONParser parseFlatData:responseString];    
    
    NSLog(@"Response: %@",responseString);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];

    NSLog(@"Error: %@",[error localizedDescription]);
}

-(void)testMethod{

}
@end
