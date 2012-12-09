//
//  HistoryTask.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 04.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryDelegate.h"

@interface HistoryTask : NSObject {
    NSURLConnection *connection;
    NSMutableData *data;
    id<HistoryDelegate>__unsafe_unretained delegate;
    int limit;
    BOOL refresh;
}

@property(nonatomic, strong) NSURLConnection *connection;
@property(nonatomic, strong) NSMutableData *data;
@property(nonatomic, unsafe_unretained) id<HistoryDelegate>delegate;
@property(nonatomic, assign) int limit;
@property(nonatomic, assign) BOOL refresh;

- (void)loadHistoryEintriesFrom:(int)_start To :(int)_end;

@end
