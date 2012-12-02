//
//  OAuthManager.h
//  libOAuthDemo
//
//  Created by Schulze, Felix on 10/21/11.
//  Copyright (c) 2011 Immobilienscout24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "OAConsumer.h"

@interface OAuthManager : NSObject {
    
}
- (void)grabURLInBackground:(NSString *)url withFormat:(NSString *)format withDelegate:(id)delegate;
- (NSString *) requestHeaderWithURL:(NSURL *)cURL andMethod:(NSString *)cMethod;
- (ASIHTTPRequest *) request:(NSURL*) url acceptFormat:(NSString*) format httpMethod:(NSString*) method;


@end
