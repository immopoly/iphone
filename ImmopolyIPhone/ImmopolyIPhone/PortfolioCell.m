//
//  PortfolioCell.m
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 07.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PortfolioCell.h"
#import "Flat.h"

@implementation PortfolioCell
@synthesize labelRooms;
@synthesize labelFlatSpace;
@synthesize flatImage;
@synthesize labelTitel;
@synthesize flat;
@synthesize labelPrice;
@synthesize labelOvertakeDate;

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
    [labelPrice release];
    [labelOvertakeDate release];
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
        
        // Convert long to date object
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"MEZ"]];
        [dateFormatter setDateFormat:@"'Übernommen am:  \t\t' dd.MM.yyyy"];
        
        long timeInterval = [flat overtakeDate]/1000; //1321922162430
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        [dateFormatter release]; 
        
        NSString *rooms = [NSString stringWithFormat:@"Zimmer: %d", [flat numberOfRooms]];
        NSString *space = [NSString stringWithFormat:@"%.0f m²",[flat livingSpace]];
        NSString *price = [NSString stringWithFormat:@"Preis: %.0f €",[flat price]];
        
        [labelTitel setText: [flat title]];
        [labelRooms setText: rooms]; 
        [labelFlatSpace setText: space];
        [labelPrice setText: price];
        [labelOvertakeDate setText:formattedDateString];
    }
}
@end
