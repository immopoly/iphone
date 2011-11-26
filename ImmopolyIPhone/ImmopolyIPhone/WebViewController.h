//
//  WebViewController.h
//
//  Created by Tobias Heine.

#import <UIKit/UIKit.h>
#import "Flat.h"
#import "UserDataDelegate.h"
#import "LoginCheck.h"
#import "FacebookManagerDelegate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface WebViewController : UIViewController <UIWebViewDelegate, UserDataDelegate, FacebookManagerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>{
	
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
-(IBAction)performFacebookPost;
-(void)reloadData;
-(IBAction)showActionSheet:(id)sender;
- (void) showEmail;
-(void)enableFlatButton:(NSTimer *)theTimer;


@end
