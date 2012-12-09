//
//  WebViewController.m
//  Created by Tobias Heine.
//

#import "WebViewController.h"
#import "ImmopolyManager.h"
#import "FlatTakeOverTask.h"
#import "FlatRemoveTask.h"
#import "FacebookManager.h"
#import "Constants.h"
#import "Secrets.h"
#import "LoginViewController.h"
#import "PortfolioViewController.h"
#import "AppDelegate.h"

@implementation WebViewController

@synthesize webView;
@synthesize activityIndicator;
@synthesize selectedExposeId;
@synthesize selectedImmoscoutFlat;
@synthesize loginCheck;
@synthesize flatActionButton;
@synthesize exposeActionButton;
@synthesize facebookButton;
@synthesize twitterButton;
@synthesize shareButton;
@synthesize mailButton;
@synthesize animating;
@synthesize buttonsVisible;
@synthesize shareBar;
@synthesize delegate;
@synthesize mapButton;
@synthesize buttons;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
        self.loginCheck = [[LoginCheck alloc] init];
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */

/*
 If you need to do additional setup after loading the view, override viewDidLoad. */
- (void)viewDidLoad {
	[self reloadData];
    
    [[FacebookManager getInstance] set_APP_KEY:facebookAppKey];
	[[FacebookManager getInstance] set_SECRET_KEY:facebookAppSecret];
    
    [FacebookManager getInstance].delegate = self;
    
    [[self flatActionButton]setEnabled:NO];
    
    [super initSpinner];
    [super.spinner setCenter:CGPointMake(265, 21)];
    [super.spinner setHidden:YES];
    
    // setting the text of the helperView
    [super initButton];
  
    //moving the button to the right site
    CGPoint pos = btHelperViewIn.center; 
    pos.x = 300.0f;
    [btHelperViewIn setCenter:pos];
    
    // setting the text of the helperView
    [super initHelperViewWithMode:INFO_EXPOSE];
    
    [[self shareButton]setImage:[UIImage imageNamed:@"webview_share.png"] forState:UIControlStateNormal];
    [[self shareButton]setImage:[UIImage imageNamed:@"webview_share_active.png"] forState:UIControlStateSelected];
    

}

-(void)enableFlatButton:(NSTimer *)_theTimer {
    [[self flatActionButton]setEnabled:YES];
}

-(void)reloadData {
    NSString *urlAddress = [[NSString alloc]initWithFormat:@"%@%i",urlIS24MobileExpose,[selectedImmoscoutFlat exposeId]];

	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
    
    if ([[[[ImmopolyManager instance]user]portfolio]containsObject:[self selectedImmoscoutFlat]]) {
        [flatActionButton setImage:[UIImage imageNamed:@"webview_give_away.png"] forState:UIControlStateNormal];
        [shareBar setFrame:CGRectMake(172, shareBar.frame.origin.y, 370, shareBar.frame.size.height)];
        [mapButton setHidden:NO];
    }else{
        [flatActionButton setImage:[UIImage imageNamed:@"webview_takeover.png"] forState:UIControlStateNormal];
        [shareBar setFrame:CGRectMake(220, shareBar.frame.origin.y, 315, shareBar.frame.size.height)];
        [mapButton setHidden:YES];
        [buttons setCenter:CGPointMake(buttons.center.x - 48, buttons.center.y)];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (IBAction)goBack {
    if ([self viewIsVisible]) {
        [self helperViewOut];
    }
    
    [self resetContent];
    
    //[self.view removeFromSuperview];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [activityIndicator startAnimating];    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
    activityIndicator.hidden=YES;
    [NSTimer scheduledTimerWithTimeInterval:(5) target:self selector:@selector(enableFlatButton:) userInfo:nil repeats:NO]; 
}

- (IBAction)flatAction {
    [super.spinner startAnimating];
    
    loginCheck.delegate = self;
    [loginCheck checkUserLogin];
    
    [self.flatActionButton setEnabled:NO];
}

#pragma mark - UserDataDelegate

- (void)performActionAfterLoginCheck {
    [self stopSpinnerAnimation];
    if ([[[[ImmopolyManager instance]user]portfolio]containsObject:[self selectedImmoscoutFlat]]) {
        
        UIAlertView *removeFlatDialog = [[UIAlertView alloc]initWithTitle:@"Expose abgeben" message:alertExposeGiveAwayWarning delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Ja", nil];
        
        removeFlatDialog.delegate = self;
        [removeFlatDialog show];
        
        [self.flatActionButton setEnabled:YES];
        
    }else{
        
        FlatTakeOverTask *flatTakeOverTask = [[FlatTakeOverTask alloc]init];
        [flatTakeOverTask takeOverFlat:[self selectedImmoscoutFlat]];
        //[self dismissModalViewControllerAnimated:YES];
    }
}

- (void)stopSpinner
{
    [self stopSpinnerAnimation];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self stopSpinnerAnimation];
    FlatRemoveTask *flatRemoveTask = [[FlatRemoveTask alloc]init];
    
    switch (buttonIndex) {
        //Nein
        case 0:
        {
            [self.flatActionButton setEnabled:YES];
            break;
        }
        //Ja                
        case 1:
        {
            [flatRemoveTask removeFlat:[self selectedImmoscoutFlat]];
            
            [[[[ImmopolyManager instance]user]portfolio]removeObject:[self selectedImmoscoutFlat]];
            [[[ImmopolyManager instance]user]setNumExposes:[[[ImmopolyManager instance]user]numExposes]-1];
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            if([[[[appDelegate tabBarController]viewControllers]objectAtIndex:1]isKindOfClass:[PortfolioViewController class]]){
                PortfolioViewController *tempVC = (PortfolioViewController *)[[[appDelegate tabBarController]viewControllers]objectAtIndex:1];
                [tempVC setPortfolioHasChanged:YES];
            }
            
            break;
        }
        default:
        {
            break;
        }
    }   
    //[self.view removeFromSuperview];
}

-(IBAction)performFacebookPost {
 
}

- (void)facebookStartedLoading {
    
}
- (void)facebookStopedLoading {
    
}

- (void)showTweet {
    Class twitterClass = NSClassFromString(@"TWTweetComposeViewController");
    
    if(!twitterClass) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:sharingTwitterAPINotAvailableAlertTitle message:sharingTwitterAPINotAvailableAlertMessage delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil];
        [alert show];
    }
    else {
        if(![TWTweetComposeViewController canSendTweet]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:sharingTwitterNoAccountAlertTitle message:sharingTwitterNoAccountAlertMessage delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil];
            [alert show];
        }
        else {
            TWTweetComposeViewController *tweetView = [[TWTweetComposeViewController alloc] init];
            
            NSString *tweetText = [NSString stringWithFormat:@"@immopoly %@",sharingTwitterMessage];
            if ([tweetText length]>140) {
                tweetText = [tweetText substringToIndex:137];
                tweetText = [tweetText stringByAppendingString:@"..."];
            }
            
            
            [tweetView setInitialText:tweetText];
            NSString *url = [NSString stringWithFormat:@"%@%i", urlIS24MobileExpose,[selectedImmoscoutFlat exposeId]];
            
            if(![tweetView addURL:[NSURL URLWithString:url]]) {
                NSLog(@"Unable to add the URL.");
            }
            
            [self presentModalViewController:tweetView animated:YES];
            
        }
    }
}

- (void)showEmail {
    
    NSMutableString* html = [[NSMutableString alloc] init];
	[html appendString:	
	 @"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\
	 <html xmlns=\"http://www.w3.org/1999/xhtml\">\
	 <head>\
	 <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />\
	 <title></title>\
	 <style type=\"text/css\">\
	 body {\
	 margin-left: 0px;\
	 margin-top: 0px;\
	 margin-right: 0px;\
	 margin-bottom: 0px;\
	 font-family:Arial, Verdana,sans-serif;\
	 }\
	 \
	 </style>\
	 </head>\
	 \
	 <body>\
	 <table width=\"100%\" height=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\
	 <tr>\
	 <td valign=\"top\"><table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\
	 <tr>\
	 \
	 <td  align=\"right\" valign=\"botton\"><table width=\"98%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\
	 <tr>\
	 <td height=\"20\"></td>\
	 </tr>\
	 <tr>\
	 <td ><font color=\"#000\" size=\"3\">Schau dir doch mal diese Wohnung an"];
	

	
	[html appendString: @"</font></td>\
	 </tr>\
	 <tr>\
	 <td height=\"20\"></td>\
	 </tr>\
	 </table></td>\
	 </tr>\
	 <tr>\
	 <td align=\"right\">\
	 \
	 <table width=\"98%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\
	 <tr>\
     "];
	
    [html appendString:@"<td width=\"60\" height=\"60\" valign=\"top\" align=\"left\"><img src=\""];
    if([[self selectedImmoscoutFlat]pictureUrl] == nil){
        [html appendString:@"https://immopoly.appspot.com/img/immopoly.png"];            
    } else {
        [html appendString:[[self selectedImmoscoutFlat] pictureUrl]];        
    }
    [html appendString: @"\" width=\"60\" height=\"60\" /></td>\""];    

    [html appendString: @"<td height=\"100\" align=\"left\" valign=\"top\"><table width=\"98%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\
	 <tr>\
	 <td><font color=\"#666\" size=\"4\"><b>"];
	
	[html appendString:[[self selectedImmoscoutFlat]name]];
	
	
	[html appendString:@"</b></font></td>\
	 </tr>\
	 <tr>\
	 \
	 <td height=\"20\"><font color=\"#999\" size=\"2\">"];
	
	[html appendString: @"</font></td>\
	 </tr>\
	 <tr>\
	 <td valign=\"top\"><font color=\"#999\" size=\"2\">"];
	
	[html appendString: [NSString stringWithFormat:@"http://mobil.immobilienscout24.de/expose/%i",[selectedImmoscoutFlat exposeId]]];

	[html appendString:  @"</font>\
	 </td>\
	 </tr>\
	 </table></td>\
	 </tr>\
	 \
	 </table></td>\
	 </tr>\
	 <tr>\
	 <td height=\"50\" align=\"right\" valign=\"bottom\"><table width=\"98%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\
	 <tr>\
	 <td width=\"20\" height=\"19\"><img src=\"http://www.suvinil.com.br/AppSuvinilCores/imgs/iphoneApp.jpg\" width=\"20\" height=\"19\"  /></td>\
	 <td ><font color=\"#999\" size=\"1\"><a href=\"http://immopoly.appspot.com/\" > via Immopoly iPhone</a></font></td>\
	 </tr>\
	 \
	 </table></td>\
	 </tr>\
	 </table>\
	 </td>\
	 </tr>\
	 </table>\
	 </body>\
	 </html>"];
    
    
	MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
    
	[controller setSubject:sharingMailSubject];
	[controller setMessageBody:html isHTML:YES];
	
    if (controller) [self presentModalViewController:controller animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction) share {
	if(!animating) {
		animating = YES;
		if(!buttonsVisible) {
			
			[[self shareButton] setSelected:YES];
			buttonsVisible = YES;
			
			[UIView beginAnimations:@"showButtons" context:nil];
			[UIView setAnimationDuration:0.4f];
			[UIView setAnimationDelegate:self];
			
            CGRect frame = [self shareBar].frame;
            
            if ([[[[ImmopolyManager instance]user]portfolio]containsObject:[self selectedImmoscoutFlat]]){
                frame.origin.x = -53;
            } else {
                frame.origin.x = 2;
            }         
            [self shareBar].frame = frame;
            			
			[UIView setAnimationDidStopSelector:@selector(animationEnded)];
			[UIView commitAnimations];
		}
		else {
			
			[[self shareButton] setSelected:NO];
			buttonsVisible = NO;
			
			[UIView beginAnimations:@"hideButtons" context:nil];
			[UIView setAnimationDuration:0.4f];
			[UIView setAnimationDelegate:self];
            
            CGRect frame = [self shareBar].frame;
            if ([[[[ImmopolyManager instance]user]portfolio]containsObject:[self selectedImmoscoutFlat]]){
                frame.origin.x = 172;
            } else {
                frame.origin.x = 220;
            }
            [self shareBar].frame = frame;
			
			[UIView setAnimationDidStopSelector:@selector(animationEnded)];
			[UIView commitAnimations];
		}
    }
}

- (void) animationEnded {
	animating = NO;
}

- (IBAction) exposeAction{
    
}
- (IBAction) email{
    [self showEmail];
}
- (IBAction) facebook{
    [[FacebookManager getInstance] beginShare];
    
    //[[FacebookManager getInstance] setFacebookText:@"FacebookText"];
    [[FacebookManager getInstance] setFacebookTitle:sharingFacebookTitle];
    [[FacebookManager getInstance] setFacebookCaption:sharingFacebookCaption];
    [[FacebookManager getInstance] setFacebookDescription:sharingFacebookDescription];
    [[FacebookManager getInstance] setFacebookImage:[selectedImmoscoutFlat pictureUrl]];
    [[FacebookManager getInstance] setFacebookLink:sharingFacebookLink];
    //[[FacebookManager getInstance] setFacebookUserPrompt:@"FacebookPrompt"];
    [[FacebookManager getInstance] setFacebookActionLabel:sharingFacebookActionLabel];
    [[FacebookManager getInstance] setFacebookActionText:sharingFacebookActionText];
    [[FacebookManager getInstance] setFacebookActionLink:[NSString stringWithFormat:@"%@%i",urlIS24MobileExpose,[selectedImmoscoutFlat exposeId]]];
    
    [[FacebookManager getInstance] commitShare];
}
- (IBAction) twitter{
    [self showTweet];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.webView = nil;
    self.activityIndicator = nil;
    self.flatActionButton = nil;
    self.exposeActionButton = nil;
    self.shareButton = nil;
    self.twitterButton = nil;
    self.facebookButton = nil;
    self.mailButton = nil;
    self.shareBar = nil;
    self.mapButton = nil;
}

- (void)resetContent {
    // resetting the webview content
    [activityIndicator setHidden:NO];
    [activityIndicator startAnimating];
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML = \"\";"];
}

- (IBAction)showFlatOnMap{
    [delegate showSelectedFlatOnMap:selectedImmoscoutFlat];
    [self goBack];
}


@end
