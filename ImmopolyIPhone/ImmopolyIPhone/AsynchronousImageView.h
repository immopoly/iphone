//
//  AsynchronousImageView.h
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 26.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Flat;

@interface AsynchronousImageView : UIImageView 

- (void)loadImageFromURLString:(NSString *)_urlString forFlat:(Flat *)_flat;
- (void)reset;

@end