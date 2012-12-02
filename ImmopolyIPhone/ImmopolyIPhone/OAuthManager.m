//
//  OAuthManager.m
//  libOAuthDemo
//
//  Created by Schulze, Felix on 10/21/11.
//  Copyright (c) 2011 Immobilienscout24. All rights reserved.
//

#import "OAuthManager.h"
#import "OAMutableURLRequest.h"
#import "Secrets.h"

#define REST_AUTHENTICATION_KEY oAuthKey
#define REST_AUTHENTICATION_SECRET oAuthSecret

@implementation OAuthManager


- (void)dealloc {
    [super dealloc];
}

- (NSString *) requestHeaderWithURL:(NSURL *)url andMethod:(NSString *)cMethod
{
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:REST_AUTHENTICATION_KEY
                                                    secret:REST_AUTHENTICATION_SECRET];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url consumer:consumer HTTPMethod:cMethod];
    [consumer release];
    
    NSString *header = [[NSString alloc] initWithString:[request oauthHeader]];
    [request release];
    
    return [header autorelease];
}

- (void)grabURLInBackground:(NSString *)url withFormat:(NSString *)format withDelegate:(id)delegate
{
    NSURL *url_request = [NSURL URLWithString:url];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url_request];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    request.userAgent = @"UserAgent";   
    request.delegate = delegate;

    [request addRequestHeader:@"Authorization" value:[self requestHeaderWithURL:url_request andMethod:@"GET"]];
    [request addRequestHeader:@"Accept" value:format];
    
    [request startAsynchronous];
}

- (ASIHTTPRequest*) request:(NSURL*)url acceptFormat:(NSString*) format httpMethod:(NSString*) method{

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    request.userAgent = @"UserAgent";   
    
    [request addRequestHeader:@"Authorization" value:[self requestHeaderWithURL:url  andMethod:method]];
    [request addRequestHeader:@"Accept" value:format];
    
    return request;
}

@end

