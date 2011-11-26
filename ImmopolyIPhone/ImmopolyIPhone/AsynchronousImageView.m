//
//  AsynchronousImageView.m
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 26.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AsynchronousImageView.h"

@implementation AsynchronousImageView
@synthesize connection, data, spinner;

- (void)loadImageFromURLString:(NSString *)theUrlString {
    
    // spinner stuff
    spinner = [[UIActivityIndicatorView alloc] init];
    [self addSubview:spinner];
    [spinner setHidesWhenStopped:YES];
    spinner.center = [self center];
    [spinner startAnimating];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theUrlString]cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)resetImage {
    self.image = nil;
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)d {
    if (data == nil)
        data = [[NSMutableData alloc] initWithCapacity:2048];
    
    [data appendData:d];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)c {
    self.image = [UIImage imageWithData:data];
    [data release], data = nil;
    [connection release], connection = nil;
    [spinner stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    self.image = [UIImage imageNamed:@"default_house.png"];
    [spinner stopAnimating];
}

@end
