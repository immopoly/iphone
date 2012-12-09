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
@property (strong, nonatomic) IBOutlet UILabel *labelRooms;
@property (strong, nonatomic) IBOutlet UILabel *labelFlatSpace;
@property (strong, nonatomic) IBOutlet AsynchronousImageView *flatImage;
@property (strong, nonatomic) IBOutlet UILabel *labelTitel;
@property (strong, nonatomic) Flat *flat;
@property (strong, nonatomic) IBOutlet UILabel *labelPrice;
@property (strong, nonatomic) IBOutlet UILabel *labelOvertakeDate;
@property (strong, nonatomic) IBOutlet UILabel *labelOvertakeTries;

@end
