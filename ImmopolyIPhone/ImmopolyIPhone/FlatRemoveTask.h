//
//  FlatRemoveTask.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 26.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Flat.h"

@interface FlatRemoveTask : NSObject<NSURLConnectionDelegate>{
    NSURLConnection *connection;
    NSMutableData *data;
    Flat *selectedImmoscoutFlat;
}

@property(nonatomic, retain) NSURLConnection *connection;
@property(nonatomic, retain) NSMutableData *data;
@property(nonatomic, retain) Flat *selectedPortfoliotFlat;

- (void)removeFlat:(Flat *)_selectedPortfoliotFlat;

@end
