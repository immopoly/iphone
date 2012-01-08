//
//  UserTask.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 07.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotifyViewDelegate.h"

@interface UserTask : NSObject{
    NSURLConnection *connection;
    NSMutableData *data;
    id<NotifyViewDelegate>delegate;
}

@property(nonatomic, retain) NSURLConnection *connection;
@property(nonatomic, retain) NSMutableData *data;
@property(nonatomic, assign) id<NotifyViewDelegate>delegate;



- (void)refreshUser:(NSString *)_userName;

@end
