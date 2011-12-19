//
//  AsynchronousImageView.m
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 26.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AsynchronousImageView.h"

@implementation AsynchronousImageView

@synthesize connection;
@synthesize data;
@synthesize spinner;
@synthesize flat;

- (void)loadImageFromURLString:(NSString *)_urlString forFlat:(Flat *)_flat{
    flat = _flat;
    
    // spinner stuff
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [self addSubview:spinner];
    [spinner setHidden:NO];
    [spinner setHidesWhenStopped:YES];
    CGPoint pos = CGPointMake(30, 30);
    [spinner setCenter:pos];
    [spinner startAnimating];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)d {
    if (data == nil)
        data = [[NSMutableData alloc] initWithCapacity:2048];
    
    [data appendData:d];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)c {
    self.image = [UIImage imageWithData:data];
    [flat setImage:self.image];
    [data release], data = nil;
    [connection release], connection = nil;
    [spinner stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    self.image = [UIImage imageNamed:@"default_house.png"];
    [flat setImage:self.image];
    [spinner stopAnimating];
}

- (void)reset {
    [spinner stopAnimating];
    [spinner setHidden:YES];
    self.image = nil;
}

- (void)dealloc {
    [spinner release];
    [data release];
    [connection release];
}

@end
