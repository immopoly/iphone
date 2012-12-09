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
#import "PortfolioDelegate.h"

@interface WebViewController : AbstractViewController <UIWebViewDelegate, UserDataDelegate, FacebookManagerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate>{
	
	IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIButton *flatActionButton;
    
    IBOutlet UIView *shareBar;
    IBOutlet UIView *buttons;
    IBOutlet UIButton *exposeAction;
    IBOutlet UIButton *shareButton;
    IBOutlet UIButton *twitterButton;
    IBOutlet UIButton *facebookButton;
    IBOutlet UIButton *mailButton;
    IBOutlet UIButton *mapButton;
    
    BOOL animating;
    BOOL buttonsVisible;
    int selectedExposeId;
    Flat *selectedImmoscoutFlat;
    LoginCheck *loginCheck;
    
    id<PortfolioDelegate> __unsafe_unretained delegate;
    
}

@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic, assign) int selectedExposeId;
@property(nonatomic, unsafe_unretained) id<PortfolioDelegate> delegate;
@property(nonatomic, strong) Flat *selectedImmoscoutFlat;
@property(nonatomic, strong) LoginCheck *loginCheck;
@property(nonatomic, strong) IBOutlet UIButton *flatActionButton;
@property(nonatomic, strong) IBOutlet UIView *shareBar;

@property(nonatomic, assign) BOOL animating;
@property(nonatomic, assign) BOOL buttonsVisible;
@property(nonatomic, strong) IBOutlet UIButton *exposeActionButton;
@property(nonatomic, strong) IBOutlet UIButton *shareButton;
@property(nonatomic, strong) IBOutlet UIButton *twitterButton;
@property(nonatomic, strong) IBOutlet UIButton *facebookButton;

@property(nonatomic, strong) IBOutlet UIButton *mailButton;
@property(nonatomic, strong) IBOutlet UIButton *mapButton;
@property(nonatomic, strong) IBOutlet UIView *buttons;

- (IBAction)goBack;
- (IBAction)flatAction;
- (IBAction)performFacebookPost;
- (IBAction)showFlatOnMap;
- (void)reloadData;
- (void) showEmail;
- (void)enableFlatButton:(NSTimer *)_theTimer;
- (void)showTweet;
- (void)resetContent;

- (IBAction) share;
- (IBAction) exposeAction;
- (IBAction) email;
- (IBAction) facebook;
- (IBAction) twitter;


@end
