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
@synthesize ownBgColor;
@synthesize shouldBeSaved;

- (void)loadImageFromURLString:(NSString *)_urlString forFlat:(Flat *)_flat{
    flat = _flat;
    
    // spinner stuff
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [self addSubview:spinner];
    [spinner setHidden:NO];
    [spinner setHidesWhenStopped:YES];
    CGPoint pos = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [spinner setCenter:pos];
    [spinner startAnimating];

    [self.imageRequest cancel];
    
    self.imageRequest = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:_urlString]] autorelease];
    self.imageRequest.delegate = self;
    [self.imageRequest startSynchronous];
    
    
    /*[self.imageRequest setCompletionBlock:^{
        UIImage* flatImage = [UIImage imageWithData:imageRequest.responseData];
        
        [flat setImage:flatImage];
        self.image = flatImage;
        if(flat == nil){
            [self setBackgroundColor:ownBgColor];
            
            if(shouldBeSaved) {
                // create NSData-object from image
                NSData *imageData;
                imageData = [NSKeyedArchiver archivedDataWithRootObject:self.image];
                // save NSData-object to UserDefaults
                [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"facebook-image"];    
            }
        }
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
    [queue addOperation:self.imageRequest];*/
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    UIImage* flatImage = [UIImage imageWithData:imageRequest.responseData];
    
    [flat setImage:flatImage];
    self.image = flatImage;
    if(flat == nil){
        [self setBackgroundColor:ownBgColor];
        
        if(shouldBeSaved) {
            // create NSData-object from image
            NSData *imageData;
            imageData = [NSKeyedArchiver archivedDataWithRootObject:self.image];
            // save NSData-object to UserDefaults
            [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"facebook-image"];    
        }
    }
    [self.spinner stopAnimating];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (![self.imageRequest isCancelled]) {
        self.image = [UIImage imageNamed:@"default_house.png"];
        [spinner stopAnimating];
        NSLog(@"image failed and request was not canceled");
    }
    else{
        NSLog(@"image failed but request was canceled");
    }
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
