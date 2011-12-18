//
//  ResetPasswordTask.h
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 18.12.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResetPasswordDelegate.h"

@interface ResetPasswordTask : NSObject {
    
    NSURLConnection *connection;
    NSMutableData *data;
    id<ResetPasswordDelegate>delegate;    
}

@property(nonatomic, retain) NSURLConnection *connection;
@property(nonatomic, retain) NSMutableData *data;
@property(nonatomic, assign) id<ResetPasswordDelegate>delegate;

- (void)performResetPasswordWithUsername:(NSString *) userName andEmail:(NSString *) email;

@end
