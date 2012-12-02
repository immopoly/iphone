//
//  CoreLocationController.h
//  CoreLocationDemo
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CoreLocationControllerDelegate<NSObject>
@required

// Our location updates are sent here
- (void)locationUpdate:(CLLocation *)_location; 

// Any errors are sent here
- (void)locationError:(NSError *)_error; 

@end

@interface CoreLocationController : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    id<CoreLocationControllerDelegate> delegate;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) id<CoreLocationControllerDelegate> delegate;
@end
