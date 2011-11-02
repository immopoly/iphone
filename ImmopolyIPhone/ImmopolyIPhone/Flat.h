//
//  Flat.h
//  libOAuthDemo
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 Immobilienscout24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Flat : NSObject <MKAnnotation> {

    int exposeId;
    NSString *name;
    NSString *description;
    NSString *locationNode;
    
    NSString *city;
    NSString *postcode;
    NSString *street;
    int houseNumber;
    NSString *quater;
    
    NSString *titlePictureSmall;
    NSString *priceValue;
    NSString *currency;
    NSString *priceIntervaleType;
    
    CLLocationCoordinate2D coordinate;
    long creationDate;
}

@property(nonatomic, readonly) int exposeId;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSString *locationNode;

@property(nonatomic, retain) NSString *city;
@property(nonatomic, retain) NSString *postcode;
@property(nonatomic, retain) NSString *street;
@property(nonatomic, assign) int houseNumber;
@property(nonatomic, retain) NSString *quater;

@property(nonatomic, retain) NSString *titlePictureSmall;
@property(nonatomic, retain) NSString *priceValue;
@property(nonatomic, retain) NSString *currency;
@property(nonatomic, retain) NSString *priceIntervaleType;
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic, assign) long creationDate;

- (id)initWithName:(NSString*)lName description:(NSString*)ldescription coordinate:(CLLocationCoordinate2D)lCoordinate exposeId:(int) lexposeId;


@end
