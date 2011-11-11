//
//  WebViewController.h
//
//  Created by Tobias Heine.

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate>{
	
	IBOutlet UIWebView *webView;
    //Spinner
    IBOutlet UIActivityIndicatorView *activityIndicator;
    int selectedExposeId;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) int selectedExposeId;
-(IBAction)goBack;
-(IBAction)takeOver;
@end
