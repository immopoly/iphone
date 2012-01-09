//
//  PortfolioCell.h
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 07.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynchronousImageView.h"

@interface PortfolioCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *labelRooms;
@property (retain, nonatomic) IBOutlet UILabel *labelFlatSpace;
@property (retain, nonatomic) IBOutlet AsynchronousImageView *flatImage;
@property (retain, nonatomic) IBOutlet UILabel *labelTitel;
@property (retain, nonatomic) Flat *flat;
@property (retain, nonatomic) IBOutlet UILabel *labelPrice;
@property (retain, nonatomic) IBOutlet UILabel *labelOvertakeDate;

@end
