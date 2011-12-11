//
//  CoreLocationController.m
//  CoreLocationDemo
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreLocationController.h"

@implementation CoreLocationController

@synthesize locationManager;
@synthesize delegate;

- (id)init {
    self = [super init];
    
    if(self != nil){
        // Create new instance of locMg
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        
        // sets the delegate as self
        self.locationManager.delegate = self;
    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    CLLocation *fhain = [[CLLocation alloc] initWithLatitude:52.517527 longitude:13.469474];
    
    // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
    if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]){
        //[self.delegate locationUpdate:newLocation];  //for real phone 
        [self.delegate locationUpdate:fhain]; // for simulator
    }
    
    [fhain release];
}
       
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
    if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]){
        [self.delegate locationError:error];
    }
}

- (void)dealloc {
    [self.locationManager release];
    [super dealloc];
}

@end
