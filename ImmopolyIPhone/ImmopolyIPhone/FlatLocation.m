//
//  FlatLocation.m
//  libOAuthDemo
//
//  Created by Maria Guseva on 26.10.11.
//  Copyright (c) 2011 Immobilienscout24. All rights reserved.
//

#import "FlatLocation.h"

@implementation FlatLocation

@synthesize name, address, coordinate,exposeId;

- (id)initWithName:(NSString*)lName address:(NSString*) lAddress coordinate:(CLLocationCoordinate2D)lCoordinate exposeId:(int) lexposeId {
    if ((self = [super init])) {
        name = [lName copy];
        address = [lAddress copy];
        coordinate = lCoordinate;
        exposeId = lexposeId;
    }
    return self;
}

- (NSString *)title {
    return name;
}

- (NSString *)subtitle {
    return address;
}

- (void)dealloc
{
    [name release];
    name = nil;
    [address release];
    address = nil;    
    [super dealloc];
}

@end