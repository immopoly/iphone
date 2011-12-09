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

- (id)initWithName:(NSString*)lName description:(NSString*)ldescription coordinate:(CLLocationCoordinate2D)lCoordinate exposeId:(int) lexposeId {
    if ((self = [super init])) {
        name = [lName copy];
        coordinate = lCoordinate;
        description = ldescription;
        exposeId = lexposeId;
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


- (void)dealloc
{
    [name release];
    name = nil;
    [description release];
    description = nil;
    [super dealloc];
}

@end
