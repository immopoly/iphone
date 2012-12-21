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
    int houseNumber;
    int numberOfRooms;
    double price;
    double livingSpace;
    long long creationDate;
    long long overtakeDate;
    int overtakeTries;
    
    NSString *name;
    NSString *description;
    NSString *locationNode;
    NSString *city;
    NSString *postcode;
    NSString *street;
    NSString *quarter;
    NSString *titlePictureSmall;
    NSString *priceIntervaleType;
    NSString *pictureUrl;

    CLLocationCoordinate2D coordinate;
    NSMutableArray *flatsAtAnnotation;
    UIImage *image;
}

@property(nonatomic, assign) int exposeId;
@property(nonatomic, assign) int houseNumber;
@property(nonatomic, assign) int numberOfRooms;
@property(nonatomic, assign) int overtakeTries;
@property(nonatomic, assign) double price;
@property(nonatomic, assign) double livingSpace;
@property(nonatomic, assign) long long creationDate;
@property(nonatomic, assign) long long overtakeDate;

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, strong) NSString *locationNode;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *postcode;
@property(nonatomic, strong) NSString *street;
@property(nonatomic, strong) NSString *quarter;
@property(nonatomic, strong) NSString *titlePictureSmall;
@property(nonatomic, strong) NSString *priceIntervaleType;
@property(nonatomic, strong) NSString *pictureUrl;

@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic, strong) NSMutableArray *flatsAtAnnotation;
@property(nonatomic, strong) UIImage *image;


- (id)initWithName:(NSString*)_name description:(NSString*)_description coordinate:(CLLocationCoordinate2D)_oordinate exposeId:(int)_lexposeId;


@end
