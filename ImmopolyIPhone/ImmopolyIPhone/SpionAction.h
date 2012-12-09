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
    id<ActionItemDelegate>__unsafe_unretained delegate;
}

@property(nonatomic, strong) NSURLConnection *connection;
@property(nonatomic, strong) NSMutableData *data;
@property(nonatomic, unsafe_unretained) id<ActionItemDelegate>delegate;

- (void)executeAction:(NSMutableArray *)_exposeIds;

@end
