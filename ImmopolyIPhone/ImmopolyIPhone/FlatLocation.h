//
//  FlatLocation.h
//  libOAuthDemo
//
//  Created by Maria Guseva on 26.10.11.
//  Copyright (c) 2011 Immobilienscout24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlatLocation : NSObject <MKAnnotation> {
    NSString *name;
    NSString *address;
    CLLocationCoordinate2D coordinate;
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*) lName address:(NSString*) lAddress coordinate:(CLLocationCoordinate2D)lCoordinate;

@end