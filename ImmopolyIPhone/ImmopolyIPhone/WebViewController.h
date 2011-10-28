//
//  WebViewController.h
//  WebViewTutorial
//
//  Created by iPhone SDK Articles on 8/19/08.
//  Copyright 2008 www.iPhoneSDKArticles.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate>{
	
	IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

-(IBAction)goBack;
@end
