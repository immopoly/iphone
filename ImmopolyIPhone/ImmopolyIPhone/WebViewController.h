//
//  WebViewController.h
//
//  Created by Tobias Heine.

#import <UIKit/UIKit.h>
#import "Flat.h"

@interface WebViewController : UIViewController <UIWebViewDelegate>{
	
	IBOutlet UIWebView *webView;
    //Spinner
    IBOutlet UIActivityIndicatorView *activityIndicator;
    int selectedExposeId;
    Flat *selectedImmoscoutFlat;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) int selectedExposeId;
@property (nonatomic, retain) Flat *selectedImmoscoutFlat;
-(IBAction)goBack;
-(IBAction)takeOver;
@end
