//
//  ImmopolyManager.m
//  ImmopolyPrototype
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ImmopolyManager.h"

@implementation ImmopolyManager

@synthesize user, loginSuccessful,flats,actLocation,delegate;

+(ImmopolyManager *) instance{
    static ImmopolyManager *instance;
    
    @synchronized(self)
    {
        if(!instance){
            instance = [[ImmopolyManager alloc] init]; // all initialisations are here
            instance.loginSuccessful = NO;
            instance.flats = [[NSMutableArray alloc]init];
            
        }
        return instance;
    }
}

-(void)callFlatsDelegate{
    [delegate displayFlatsOnMap];
}

-(void)callLocationDelegate {
    [delegate displayCurrentLocation];
}

@end
