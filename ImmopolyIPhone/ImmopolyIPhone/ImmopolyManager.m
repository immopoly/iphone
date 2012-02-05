//
//  ImmopolyManager.m
//  ImmopolyPrototype
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ImmopolyManager.h"

@implementation ImmopolyManager

@synthesize user;
@synthesize loginSuccessful;
@synthesize immoScoutFlats;
@synthesize actLocation;
@synthesize delegate;
@synthesize selectedExposeId;
@synthesize willComeBack;

+ (ImmopolyManager *)instance {
    static ImmopolyManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance =  [[ImmopolyManager alloc] init];
    });
    return instance;
}

- (id)init{
    self = [super init];
    self.immoScoutFlats = [NSMutableArray array];
    self.willComeBack = NO;
    return self;
}



-(void)showFlatSpinner{
    [delegate showFlatSpinner];
}

- (void)callFlatsDelegate {
    [delegate displayFlatsOnMap];
}

- (void)callLocationDelegate {
    [delegate displayCurrentLocation];
}

- (void)dealloc {
    [immoScoutFlats release];
}

@end
