//
//  OAMutableURLRequest.m
//  OAuthConsumer
//
//  Created by Jon Crosby on 10/19/07.
//  Copyright 2007 Kaboomerang LLC. All rights reserved.
//
//  Modified by Felix Schulze on 03/30/11.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "OAMutableURLRequest.h"


@interface OAMutableURLRequest (Private)
- (NSString *)getSignatureBaseString;
- (void)generateNonce;
- (void)generateTimestamp;
- (void)prepare;
@end

@implementation OAMutableURLRequest

@synthesize oauthHeader;
#pragma mark init

- (id)initWithURL:(NSURL *)aUrl consumer:(OAConsumer *)aConsumer HTTPMethod:(NSString *)aHTTPMethod

{
    if ((self = [super initWithURL:aUrl
                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                   timeoutInterval:10.0]))
	{    
        [self setHTTPMethod:aHTTPMethod];
		consumer = [aConsumer retain];
		signatureProvider = [[OAHMAC_SHA1SignatureProvider alloc] init];
        
		[self generateTimestamp];
		[self generateNonce];
        [self prepare];
	}
    return self;
}

- (id)initWithURL:(NSURL *)aUrl consumer:(OAConsumer *)aConsumer xconsumer:(XOAConsumer *)aXConsumer HTTPMethod:(NSString *)aHTTPMethod

{
    if ((self = [super initWithURL:aUrl
                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                   timeoutInterval:10.0]))
	{    
        [self setHTTPMethod:aHTTPMethod];
		consumer = [aConsumer retain];
        xConsumer = [aXConsumer retain];
		signatureProvider = [[OAHMAC_SHA1SignatureProvider alloc] init];
        
		[self generateTimestamp];
		[self generateNonce];
        [self prepare];
	}
    return self;
}

- (void)dealloc
{
    [xConsumer release];
	[consumer release];
	[signatureProvider release];
	[timestamp release];
	[nonce release];
	[extraOAuthParameters release];
	[super dealloc];
}

#pragma mark -
#pragma mark Private

- (void)prepare 
{
    // sign
	// First secrets must be urlencoded before concatenated with '&'
    NSString *key = [NSString stringWithFormat:@"%@&%@",
					 [consumer.secret URLEncodedString],
					 xConsumer.secret ? xConsumer.secret : @""]; 
    
    NSString *signature = [signatureProvider signClearText:[self getSignatureBaseString] withSecret:key];
    
	NSMutableString *extraParameters = [NSMutableString string];
	
	// Adding the optional parameters in sorted order isn't required by the OAuth spec, but it makes it possible to hard-code expected values in the unit tests.
	for(NSString *parameterName in [[extraOAuthParameters allKeys] sortedArrayUsingSelector:@selector(compare:)])
	{
		[extraParameters appendFormat:@", %@=\"%@\"",
		 [parameterName URLEncodedString],
		 [[extraOAuthParameters objectForKey:parameterName] URLEncodedString]];
	}	
    
    if (!xConsumer) { 
        oauthHeader = [NSString stringWithFormat:@"OAuth oauth_consumer_key=\"%@\", oauth_signature_method=\"%@\", oauth_signature=\"%@\", oauth_timestamp=\"%@\", oauth_nonce=\"%@\", oauth_version=\"1.0\"%@",
                       [consumer.key URLEncodedString],
                       [[signatureProvider name] URLEncodedString],
                       [signature URLEncodedString],
                       timestamp,
                       nonce,
                       extraParameters];
    }
    else {
        oauthHeader = [NSString stringWithFormat:@"OAuth oauth_consumer_key=\"%@\", oauth_token=\"%@\", oauth_signature_method=\"%@\", oauth_signature=\"%@\", oauth_timestamp=\"%@\", oauth_nonce=\"%@\", oauth_version=\"1.0\"%@",
                       [consumer.key URLEncodedString],
                       [xConsumer.token URLEncodedString],
                       [[signatureProvider name] URLEncodedString],
                       [signature URLEncodedString],
                       timestamp,
                       nonce,
                       extraParameters];
    }
}

- (void)generateTimestamp 
{
    timestamp = [[NSString stringWithFormat:@"%d", time(NULL)] retain];
}

- (void)generateNonce 
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    NSMakeCollectable(theUUID);
    nonce = (NSString *)string;
    CFRelease(theUUID);
}

- (NSString *)getSignatureBaseString 
{
    // OAuth Spec, Section 9.1.1 "Normalize Request Parameters"
    // build a sorted array of both request parameters and OAuth header parameters
    NSMutableArray *parameterPairs = [NSMutableArray  arrayWithCapacity:(6 + [[self parameters] count])]; // 6 being the number of OAuth params in the Signature Base String
    
	[parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_consumer_key" value:consumer.key] URLEncodedNameValuePair]];
	[parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_signature_method" value:[signatureProvider name]] URLEncodedNameValuePair]];
	[parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_timestamp" value:timestamp] URLEncodedNameValuePair]];
	[parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_nonce" value:nonce] URLEncodedNameValuePair]];
	[parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_version" value:@"1.0"] URLEncodedNameValuePair]];
    
    if (xConsumer) {
        [parameterPairs addObject:[[OARequestParameter requestParameterWithName:@"oauth_token" value:xConsumer.token] URLEncodedNameValuePair]];
    }
    
    for (OARequestParameter *param in [self parameters]) {
        [parameterPairs addObject:[param URLEncodedNameValuePair]];
    }
    
    NSArray *sortedPairs = [parameterPairs sortedArrayUsingSelector:@selector(compare:)];
    NSString *normalizedRequestParameters = [sortedPairs componentsJoinedByString:@"&"];
    
    // OAuth Spec, Section 9.1.2 "Concatenate Request Elements"
    NSString *signatureBaseString = [NSString stringWithFormat:@"%@&%@&%@",
					 [self HTTPMethod],
					 [[[self URL] URLStringWithoutQuery] URLEncodedString],
					 [normalizedRequestParameters URLEncodedString]];
    return signatureBaseString;
}


@end
