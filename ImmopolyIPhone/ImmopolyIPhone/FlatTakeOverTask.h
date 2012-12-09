//
//  FlatTakeOverTask.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 31.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HistoryEntry.h"
#import "Flat.h"

@interface FlatTakeOverTask : NSObject<NSURLConnectionDelegate>{
    NSURLConnection *connection;
    NSMutableData *data;
    Flat *selectedImmoscoutFlat;
}

@property(nonatomic, strong) NSURLConnection *connection;
@property(nonatomic, strong) NSMutableData *data;
@property(nonatomic, strong) Flat *selectedImmoscoutFlat;

- (void)takeOverFlat:(Flat *)_selectedImmoscoutFlat;

@end
