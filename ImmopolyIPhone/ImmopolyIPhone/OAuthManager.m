//
//  OAuthManager.m
//  libOAuthDemo
//
//  Created by Schulze, Felix on 10/21/11.
//  Copyright (c) 2011 Immobilienscout24. All rights reserved.
//

#import "OAuthManager.h"
#import "OAMutableURLRequest.h"

#error insert key/value
#define REST_AUTHENTICATION_KEY @""
#define REST_AUTHENTICATION_SECRET @""

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

- (ASIHTTPRequest *)grabURLInBackground:(NSString *)url withFormat:(NSString *)format withDelegate:(id)delegate
{
    NSURL *url_request = [NSURL URLWithString:url];
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url_request] autorelease];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    request.userAgent = @"UserAgent";   
    request.delegate = delegate;

    [request addRequestHeader:@"Authorization" value:[self requestHeaderWithURL:url_request andMethod:@"GET"]];
    [request addRequestHeader:@"Accept" value:format];
    
    [request startAsynchronous];
        
    return request;
}

- (ASIHTTPRequest*) request:(NSURL*)url acceptFormat:(NSString*) format httpMethod:(NSString*) method{

    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    request.userAgent = @"UserAgent";   
    
    [request addRequestHeader:@"Authorization" value:[self requestHeaderWithURL:url  andMethod:method]];
    [request addRequestHeader:@"Accept" value:format];
    
    return request;
}

@end

