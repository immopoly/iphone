//
//  WebViewController.h
//
//  Created by Tobias Heine.

#import <UIKit/UIKit.h>
#import "Flat.h"
#import "UserDataDelegate.h"
#import "LoginCheck.h"

@interface WebViewController : UIViewController <UIWebViewDelegate, UserDataDelegate>{
	
	IBOutlet UIWebView *webView;
    //Spinner
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIButton *flatActionButton;
    int selectedExposeId;
    Flat *selectedImmoscoutFlat;
    LoginCheck *loginCheck;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) int selectedExposeId;
@property (nonatomic, retain) Flat *selectedImmoscoutFlat;
@property(nonatomic, retain) LoginCheck *loginCheck;
@property(nonatomic, retain) IBOutlet UIButton *flatActionButton;

-(IBAction)goBack;
-(IBAction)flatAction;
-(void)reloadData;

@end
