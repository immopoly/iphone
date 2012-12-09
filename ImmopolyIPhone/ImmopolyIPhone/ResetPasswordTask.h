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
    id<ResetPasswordDelegate>__unsafe_unretained delegate;    
}

@property(nonatomic, strong) NSURLConnection *connection;
@property(nonatomic, strong) NSMutableData *data;
@property(nonatomic, unsafe_unretained) id<ResetPasswordDelegate>delegate;

- (void)performResetPasswordWithUsername:(NSString *) userName andEmail:(NSString *) email;

@end
