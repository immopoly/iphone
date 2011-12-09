 //
//  FlatProvider.h
//  libOAuthDemo
//
//  Created by Tobias Heine on 26.10.11.
//  Copyright (c) 2011 Immobilienscout24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlatProvider : NSObject


- (void)getFlatsFromLocation:(CLLocationCoordinate2D)_location;


@end
