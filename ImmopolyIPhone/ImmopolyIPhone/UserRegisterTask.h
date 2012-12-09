//
//  UserRegisterTask.h
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 17.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegisterDelegate.h"

@interface UserRegisterTask : NSObject {
    NSURLConnection *connection;
    NSMutableData *data;
    id<RegisterDelegate>__unsafe_unretained delegate;
}

@property(nonatomic, strong) NSURLConnection *connection;
@property(nonatomic, strong) NSMutableData *data;
@property(nonatomic, unsafe_unretained) id<RegisterDelegate>delegate;

- (void)performRegistration:(NSString *)_userName withPassword:(NSString *)_password withEmail:(NSString *)_email withTwitter:(NSString *)_twitter;

@end
