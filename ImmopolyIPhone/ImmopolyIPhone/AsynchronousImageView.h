//
//  AsynchronousImageView.h
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 26.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Flat.h"

@interface AsynchronousImageView : UIImageView 
{
    NSURLConnection *connection;
    NSMutableData *data;
    UIActivityIndicatorView *spinner;
    Flat *flat;
}

@property(nonatomic, retain) NSURLConnection *connection;
@property(nonatomic, retain) NSMutableData *data;
@property(nonatomic, retain) UIActivityIndicatorView *spinner;
@property(nonatomic, retain) Flat *flat;

- (void)loadImageFromURLString:(NSString *)_urlString forFlat:(Flat *)_flat;
- (void)reset;

@end