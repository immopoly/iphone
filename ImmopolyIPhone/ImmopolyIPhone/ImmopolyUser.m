//
//  ImmopolyUser.m
//  ImmopolyPrototype
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ImmopolyUser.h"

@implementation ImmopolyUser

@synthesize  userName;
@synthesize userToken;
@synthesize email;
@synthesize balance;
@synthesize lastProvision;
@synthesize lastRent;
@synthesize portfolio;
@synthesize history;
@synthesize badges;
@synthesize numExposes;
@synthesize maxExposes;
@synthesize actionItems;


- (id)init
{
    self = [super init];
    if (self) {
        portfolio = [[NSMutableArray alloc]init];
        history = [[NSMutableArray alloc]init];
        badges = [[NSMutableArray alloc]init];
        actionItems = [[NSMutableArray alloc]init]; 
    }
    
    return self;
}

-(void)dealloc {
    [portfolio release];
    [history release];
    [badges release];
    [actionItems release];
    [userName release];
    [userToken release];
    [email release];
    [super dealloc];
}

@end
