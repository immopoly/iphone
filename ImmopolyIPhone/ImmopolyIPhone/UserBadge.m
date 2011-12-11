//
//  UserBadge.m
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 09.12.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import "UserBadge.h"

@implementation UserBadge

@synthesize amount;
@synthesize text;
@synthesize time;
@synthesize type;
@synthesize url;


-(void)dealloc {
    [text release];
    [url release];
    [super dealloc];
}

@end
