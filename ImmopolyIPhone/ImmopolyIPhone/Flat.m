//
//  Flat.m
//  libOAuthDemo
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 Immobilienscout24. All rights reserved.
//

#import "Flat.h"

@implementation Flat
@synthesize exposeId, name, description, locationNode; 
@synthesize city, postcode, street, houseNumber, quarter; 
@synthesize titlePictureSmall, price, currency, priceValue, priceIntervaleType, creationDate;
@synthesize numberOfRooms, livingSpace, coordinate, pictureUrl, flatsAtAnnotation;

- (id)initWithName:(NSString*)_name description:(NSString*)_description coordinate:(CLLocationCoordinate2D)_coordinate exposeId:(int)_exposeId {
    if ((self = [super init])) {
        name = [_name copy];
        coordinate = _coordinate;
        description = _description;
        exposeId = _exposeId;
        flatsAtAnnotation = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

- (NSString *)title {
    return name;
}


- (NSString *)subtitle {
    return description;
}


- (void)dealloc {
    [name release];
    name = nil;
    [description release];
    description = nil;
    [super dealloc];
}

@end
