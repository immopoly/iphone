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
    id<HistoryDelegate>delegate;
    int limit;
}

@property(nonatomic, retain) NSURLConnection *connection;
@property(nonatomic, retain) NSMutableData *data;
@property(nonatomic, assign) id<HistoryDelegate>delegate;
@property(nonatomic, assign) int limit;

- (void)loadHistoryEintriesFrom:(int)start To :(int)end;

@end
