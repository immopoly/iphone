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

@property(nonatomic, strong) NSURLConnection *connection;
@property(nonatomic, strong) NSMutableData *data;
@property(nonatomic, strong) Flat *selectedPortfoliotFlat;

- (void)removeFlat:(Flat *)_selectedPortfoliotFlat;

@end
