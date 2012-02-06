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
    NSMutableArray *immoScoutFlats;
    CLLocation *actLocation;
    id<LocationDelegate, FlatsDelegate>delegate;
    int selectedExposeId;
    BOOL willComeBack;
}

@property(nonatomic, assign) id<LocationDelegate>delegate;
@property(nonatomic, retain) ImmopolyUser *user;
@property(nonatomic, assign) BOOL loginSuccessful;
@property(nonatomic, assign) BOOL willComeBack;
@property(nonatomic, retain) NSMutableArray *immoScoutFlats;
@property(nonatomic, retain) CLLocation *actLocation;
@property(nonatomic, assign) int selectedExposeId;

- (void)callLocationDelegate;
- (void)callFlatsDelegate;
- (void)showFlatSpinner;
+ (ImmopolyManager *) instance;

@end
