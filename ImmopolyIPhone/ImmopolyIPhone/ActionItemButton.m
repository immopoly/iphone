//
//  ActionItemButton.m
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 28.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionItemButton.h"

@implementation ActionItemButton
@synthesize item;

- (id)init:(ActionItem *)_item{
    self = [super init];
    self.item = item;
    return self;
}

-(void)dealloc{
    [item release];  
}
@end
