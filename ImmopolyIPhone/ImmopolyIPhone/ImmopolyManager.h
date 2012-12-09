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
    id<LocationDelegate, FlatsDelegate>__unsafe_unretained delegate;
    int selectedExposeId;
    BOOL willComeBack;
}

@property(nonatomic, unsafe_unretained) id<LocationDelegate>delegate;
@property(nonatomic, strong) ImmopolyUser *user;
@property(nonatomic, assign) BOOL loginSuccessful;
@property(nonatomic, assign) BOOL willComeBack;
@property(nonatomic, strong) NSMutableArray *immoScoutFlats;
@property(nonatomic, strong) CLLocation *actLocation;
@property(nonatomic, assign) int selectedExposeId;

- (void)callLocationDelegate;
- (void)callFlatsDelegate;
- (void)showFlatSpinner;
+ (ImmopolyManager *) instance;

@end
