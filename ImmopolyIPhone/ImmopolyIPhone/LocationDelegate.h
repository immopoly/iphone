//
//  LocationDelegate.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 28.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocationDelegate <NSObject>

-(void) displayCurrentLocation;
-(void) setAdressLabelText:(NSString *)locationName;

@end
