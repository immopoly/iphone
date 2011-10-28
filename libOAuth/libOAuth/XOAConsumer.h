//
//  XOAConsumer.h
//  libOAuth
//
//  Created by felixschulze on 27.07.11.
//  Copyright 2011 Immobilienscout24. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XOAConsumer : NSObject {
@protected
	NSString *token;
	NSString *secret;
}
@property(retain) NSString *token;
@property(retain) NSString *secret;

- (id)initWithToken:(NSString *)aToken secret:(NSString *)aSecret;

@end
