//
//  AsynchronousImageView.m
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 26.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AsynchronousImageView.h"
#import "ASIHTTPRequest.h"
#import "Flat.h"

@interface AsynchronousImageView () {
    UIActivityIndicatorView *spinner;
    Flat *flat;
}

@property(nonatomic, retain) ASIHTTPRequest *imageRequest;
@property(nonatomic, retain) UIActivityIndicatorView *spinner;
@property(nonatomic, retain) Flat *flat;
    
@end

@implementation AsynchronousImageView

@synthesize spinner;
@synthesize flat;
@synthesize imageRequest;

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

    [self.imageRequest cancel];
    
    self.imageRequest = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:_urlString]] autorelease];
    [self.imageRequest setCompletionBlock:^{
        UIImage* flatImage = [UIImage imageWithData:imageRequest.responseData];
        [flat setImage:flatImage];
        self.image = flatImage;
        [self.spinner stopAnimating];
    }];
    [self.imageRequest setFailedBlock:^{
        if (![self.imageRequest isCancelled]) {
            self.image = [UIImage imageNamed:@"default_house.png"];
            [spinner stopAnimating];
            NSLog(@"image failed and request was not canceled");
        }
        else{
            NSLog(@"image failed but request was canceled");
        }
    }];
    NSOperationQueue* queue = [[[NSOperationQueue alloc] init] autorelease];
    [queue addOperation:self.imageRequest];
}

- (void)reset {
    [spinner stopAnimating];
    [spinner setHidden:YES];
    self.image = nil;
}

- (void)dealloc {
    [spinner release];
}

@end
