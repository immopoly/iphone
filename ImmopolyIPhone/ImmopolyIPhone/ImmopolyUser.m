//
//  ImmopolyUser.m
//  ImmopolyPrototype
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ImmopolyUser.h"

@implementation ImmopolyUser
@synthesize  userName,userToken,email,twitter,balance,lastProvision,lastRent,portfolio,history;
@synthesize badges;

- (id)init
{
    self = [super init];
    if (self) {
        portfolio = [[NSMutableArray alloc]init];
        history = [[NSMutableArray alloc]init];
        badges = [[NSMutableArray alloc]init];
    }
    
    return self;
}

@end
