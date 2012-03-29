//
//  SpionAction.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 28.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionItemDelegate.h"

@interface SpionAction : NSObject{
    NSURLConnection *connection;
    NSMutableData *data;
    id<ActionItemDelegate>delegate;
}

@property(nonatomic, retain) NSURLConnection *connection;
@property(nonatomic, retain) NSMutableData *data;
@property(nonatomic, assign) id<ActionItemDelegate>delegate;

- (void)executeAction:(NSMutableArray *)_exposeIds;

@end
