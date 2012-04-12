//
//  ScrollViewItem.m
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 30.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScrollViewItem.h"

@implementation ScrollViewItem

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
