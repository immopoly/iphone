//
//  DataLoader.h
//  ImmopolyPrototype
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginDelegate.h"

@interface DataLoader : NSObject {
    NSURLConnection *connection;
    NSMutableData *data;
    id<LoginDelegate>delegate;
    
}

@property(nonatomic, retain) NSURLConnection *connection;
@property(nonatomic, retain) NSMutableData *data;
@property(nonatomic, assign) id<LoginDelegate>delegate;

- (void)performLogin:(NSString *)userName password:(NSString *)password;


@end
