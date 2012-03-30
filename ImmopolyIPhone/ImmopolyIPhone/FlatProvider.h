 //
//  FlatProvider.h
//  libOAuthDemo
//
//  Created by Tobias Heine on 26.10.11.
//  Copyright (c) 2011 Immobilienscout24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define SEARCH_MIN_RESULTS 50
#define SEARCH_MAX_RESULTS 80

@interface FlatProvider : NSObject {
    // counter variable for getting flats from location of 5 pages
    int pageNum; 
    int idxRadius;
    BOOL maxRadiusReached;
    CLLocationCoordinate2D location;
}

- (void)getFlatsFromLocation:(CLLocationCoordinate2D)_location;
- (void)getExposeFromId:(int)_exposeId;
- (void)getFlatsFromLocationAndPageNumber:(int)_pageNumber andRadius:(int)_radius;

@property(nonatomic, assign) CLLocationCoordinate2D location;
@property(nonatomic, assign) int pageNum;
@property(nonatomic, assign) int idxRadius;
@property(nonatomic, assign) BOOL maxRadiusReached;

@end
