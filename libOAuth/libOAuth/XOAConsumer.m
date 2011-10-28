//
//  XOAConsumer.m
//  libOAuth
//
//  Created by felixschulze on 27.07.11.
//  Copyright 2011 Immobilienscout24. All rights reserved.
//

#import "XOAConsumer.h"

@implementation XOAConsumer

@synthesize token = __token;
@synthesize secret = __secret;

#pragma mark init

- (id)initWithToken:(NSString *)aToken secret:(NSString *)aSecret 
{
    self = [super init];
	if (self)
	{
		self.token = aToken;
		self.secret = aSecret;
	}
	return self;
}

- (void)dealloc
{
    self.token = nil;
    self.secret = nil;
	[super dealloc];
}

@end
