//
//  ImmopolyUser.m
//  ImmopolyPrototype
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ImmopolyUser.h"

@implementation ImmopolyUser
@synthesize  userName,userToken,email,twitter,balance,lastProvision,lastRent,portfolio;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
