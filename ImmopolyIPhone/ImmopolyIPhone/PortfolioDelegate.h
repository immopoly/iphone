//
//  PortfolioDelegate.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 07.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Flat.h"

@protocol PortfolioDelegate <NSObject>

- (void)showSelectedFlatOnMap:(Flat *)flat;

@end
