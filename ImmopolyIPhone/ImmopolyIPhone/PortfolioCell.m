//
//  PortfolioCell.m
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 07.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PortfolioCell.h"

@implementation PortfolioCell
@synthesize labelRooms;
@synthesize labelFlatSpace;
@synthesize flatImage;
@synthesize labelTitel;
@synthesize flat;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [labelTitel release];
    [labelRooms release];
    [labelFlatSpace release];
    [flatImage release];
    [flat release];
    [super dealloc];
}

- (void)setFlat:(Flat *)_flat {
    if(flat != _flat) {
        
        [_flat retain];
        [flat release];
        flat = _flat;
        
        [flatImage reset];
        
        if([flat image] == nil) {
            [flatImage loadImageFromURLString:[flat pictureUrl] forFlat:flat];
            
        } else {
            [flatImage setImage:[flat image]];
        }
        
        NSString *rooms = [NSString stringWithFormat:@"Zimmer: %d", [flat numberOfRooms]];
        NSString *space = [NSString stringWithFormat:@"qm: %.2f", [flat livingSpace]];
        
        [labelTitel setText: [flat title]];
        [labelRooms setText: rooms]; 
        [labelFlatSpace setText: space];
    }
}
@end
