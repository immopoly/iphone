//
//  ImmopolyManager.h
//  ImmopolyPrototype
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImmopolyUser.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationDelegate.h"
#import "FlatsDelegate.h"


@interface ImmopolyManager : NSObject {
    ImmopolyUser *user;
    BOOL loginSuccessful;
    NSMutableArray *flats;
    CLLocation *actLocation;
    id<LocationDelegate, FlatsDelegate>delegate;
    int selectedExposeId;
}

-(void)callLocationDelegate;

+ (ImmopolyManager *) instance;

@property(nonatomic, assign) id<LocationDelegate>delegate;
@property(nonatomic, retain) ImmopolyUser *user;
@property(nonatomic, assign) BOOL loginSuccessful;
@property(nonatomic, assign) NSMutableArray *flats;
@property(nonatomic, assign) CLLocation *actLocation;
@property(nonatomic, assign) int selectedExposeId;
@end
