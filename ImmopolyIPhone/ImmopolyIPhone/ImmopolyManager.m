//
//  ImmopolyManager.m
//  ImmopolyPrototype
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ImmopolyManager.h"

@implementation ImmopolyManager

@synthesize user, loginSuccessful,ImmoScoutFlats,actLocation,delegate,selectedExposeId;

+(ImmopolyManager *) instance{
    static ImmopolyManager *instance;
    
    @synchronized(self)
    {
        if(!instance){
            instance = [[ImmopolyManager alloc] init]; // all initialisations are here
            instance.loginSuccessful = NO;
            instance.ImmoScoutFlats = [[NSMutableArray alloc]init];
            
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
