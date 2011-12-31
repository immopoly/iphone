//
//  WebViewController.h
//
//  Created by Tobias Heine.

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import "Flat.h"
#import "UserDataDelegate.h"
#import "LoginCheck.h"
#import "FacebookManagerDelegate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AbstractViewController.h"

@interface WebViewController : AbstractViewController <UIWebViewDelegate, UserDataDelegate, FacebookManagerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate>{
	
	IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UIButton *flatActionButton;
    
    IBOutlet UIView *shareBar;
    IBOutlet UIButton *exposeAction;
    IBOutlet UIButton *shareButton;
    IBOutlet UIButton *twitterButton;
    IBOutlet UIButton *facebookButton;
    IBOutlet UIButton *mailButton;
    
    BOOL animating;
    BOOL buttonsVisible;
    int selectedExposeId;
    Flat *selectedImmoscoutFlat;
    LoginCheck *loginCheck;
}

@property(nonatomic, retain) UIWebView *webView;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic, retain) IBOutlet IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic, assign) int selectedExposeId;
@property(nonatomic, retain) Flat *selectedImmoscoutFlat;
@property(nonatomic, retain) LoginCheck *loginCheck;
@property(nonatomic, retain) IBOutlet UIButton *flatActionButton;
@property(nonatomic, retain) IBOutlet UIView *shareBar;

@property(nonatomic, assign) BOOL animating;
@property(nonatomic, assign) BOOL buttonsVisible;
@property(nonatomic, retain) IBOutlet UIButton *exposeActionButton;
@property(nonatomic, retain) IBOutlet UIButton *shareButton;
@property(nonatomic, retain) IBOutlet UIButton *twitterButton;
@property(nonatomic, retain) IBOutlet UIButton *facebookButton;
@property(nonatomic, retain) IBOutlet UIButton *mailButton;

- (IBAction)goBack;
- (IBAction)flatAction;
- (IBAction)performFacebookPost;
- (void)reloadData;
- (void)stopSpinnerAnimation;
- (void) showEmail;
- (void)enableFlatButton:(NSTimer *)_theTimer;
- (void)showTweet;

- (IBAction) share;
- (IBAction) exposeAction;
- (IBAction) email;
- (IBAction) facebook;
- (IBAction) twitter;


@end
