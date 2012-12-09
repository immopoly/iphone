//
//  DataLoader.h
//  ImmopolyPrototype
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginDelegate.h"

@interface UserLoginTask : NSObject {
    NSURLConnection *connection;
    NSMutableData *data;
    id<LoginDelegate>__unsafe_unretained delegate;
}

@property(nonatomic, strong) NSURLConnection *connection;
@property(nonatomic, strong) NSMutableData *data;
@property(nonatomic, unsafe_unretained) id<LoginDelegate>delegate;

- (void)performLogin:(NSString *)_userName password:(NSString *)_password;
- (void)performLoginWithToken:(NSString *)_userToken;

@end
