//
//  Flat.h
//  libOAuthDemo
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 Immobilienscout24. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flat : NSObject {
    int uid;
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
    double lat;
    double lng;
    long creationDate;
}

@property(nonatomic, assign) int uid;
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
@property(nonatomic, assign) double lat;
@property(nonatomic, assign) double lng;
@property(nonatomic, assign) long creationDate;

@end
