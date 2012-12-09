//
//  ActionItemButton.m
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 28.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionItemButton.h"
#import "AsynchronousImageView.h"

@implementation ActionItemButton
@synthesize item;

- (id)initWithActionItem:(ActionItem *)_item{
    self = [super init];
    self.item = _item;
    
    AsynchronousImageView *image = [[AsynchronousImageView alloc]init];
    [image loadImageFromURLString:[item url] forFlat:nil];
    
    [self setBackgroundImage:[image image] forState:UIControlStateNormal];
    
    return self;
}

@end
