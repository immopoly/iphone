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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
        self.loginCheck = [[LoginCheck alloc] init];
	}
	return self;
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
    
    [flatActionButton setTitle: @"Disabled" forState: UIControlStateDisabled];
    [[self flatActionButton]setEnabled:NO];
    
    NSTimer *rat =[NSTimer scheduledTimerWithTimeInterval:(5) target:self selector:@selector(enableFlatButton:) userInfo:nil repeats:NO]; 
    
}

-(void)enableFlatButton:(NSTimer *)_theTimer {
    [[self flatActionButton]setEnabled:YES];
}

-(void)reloadData {
    NSString *urlAddress = [[NSString alloc]initWithFormat:@"%@%i",urlIS24MobileExpose,[selectedImmoscoutFlat exposeId]];

	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
    [urlAddress release];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
    
    if ([[[[ImmopolyManager instance]user]portfolio]containsObject:[self selectedImmoscoutFlat]]) {
        //[flatActionButton setTitle: @"Expose abgeben" forState: UIControlStateNormal];
        [flatActionButton setImage:[UIImage imageNamed:@"webview_give_away.png"] forState:UIControlStateNormal];
    }else{
        //[flatActionButton setTitle: @"Expose übernehmen" forState: UIControlStateNormal];
        [flatActionButton setImage:[UIImage imageNamed:@"webview_takeover.png"] forState:UIControlStateNormal];
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
	[webView release];
    [activityIndicator release];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [loginCheck release];
	[super dealloc];
}

- (IBAction)goBack {
    [self.view removeFromSuperview];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [activityIndicator startAnimating];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
    activityIndicator.hidden=YES;
}

- (IBAction)flatAction {
     
    //FlatTakeOverTask *flatTask = [[FlatTakeOverTask alloc]init];
    //[flatTask takeOverFlat:[self selectedImmoscoutFlat]];
    loginCheck.delegate = self;
    [loginCheck checkUserLogin];
}

- (void)performActionAfterLoginCheck {
    
    if ([[[[ImmopolyManager instance]user]portfolio]containsObject:[self selectedImmoscoutFlat]]) {
        
        UIAlertView *removeFlatDialog = [[UIAlertView alloc]initWithTitle:@"Expose abgeben" message:alertExposeGiveAwayWarning delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Ja", nil];
        
        [removeFlatDialog show];
        [removeFlatDialog release];
        
    }else{
        FlatTakeOverTask *flatTakeOverTask = [[FlatTakeOverTask alloc]init];
        [flatTakeOverTask takeOverFlat:[self selectedImmoscoutFlat]];
        [self.view removeFromSuperview];
        [flatTakeOverTask release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    FlatRemoveTask *flatRemoveTask = [[FlatRemoveTask alloc]init];
    
    switch (buttonIndex) {
        //Nein
        case 0:
            [flatRemoveTask release];
        break;
        //Ja                
        case 1:
            [flatRemoveTask removeFlat:[self selectedImmoscoutFlat]];
        break;
            
        default:
            break;
    }   
    [self.view removeFromSuperview];
    [flatRemoveTask release];
}

-(IBAction)performFacebookPost {
 
}

- (void)facebookStartedLoading {
    
}
- (void)facebookStopedLoading {
    
}

- (IBAction)showActionSheet:(id)sender {

    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:sharingActionSheetTitle delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Abbrechen" otherButtonTitles:@"Facebook", @"Twitter", @"Mail", nil];

    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;

    [popupQuery showInView:self.view];

    [popupQuery release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    if (buttonIndex == 1) {

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
        [[FacebookManager getInstance] setFacebookActionLink:[[NSString alloc]initWithFormat:@"%@%i",urlIS24MobileExpose,[selectedImmoscoutFlat exposeId]]];
        
        [[FacebookManager getInstance] commitShare];

    }
    else if (buttonIndex == 2) {
        //Twitter
        [self showTweet];
        
    }
    else if (buttonIndex == 3) {
        //Mail
        [self showEmail];
        
    } 
}

- (void)showTweet {
    Class twitterClass = NSClassFromString(@"TWTweetComposeViewController");
    
    if(!twitterClass) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:sharingTwitterAPINotAvailableAlertTitle message:sharingTwitterAPINotAvailableAlertMessage delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else {
        if(![TWTweetComposeViewController canSendTweet]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:sharingTwitterNoAccountAlertTitle message:sharingTwitterNoAccountAlertMessage delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil];
            [alert show];
            [alert release]; 
        }
        else {
            TWTweetComposeViewController *tweetView = [[TWTweetComposeViewController alloc] init];
            [tweetView setInitialText:sharingTwitterMessage];
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
	 <td width=\"60\" height=\"60\" valign=\"top\" align=\"left\"><img src=\""];
	
	[html appendString:[[self selectedImmoscoutFlat]pictureUrl]];	  
	
	[html appendString: @"\" width=\"60\" height=\"60\" /></td>\
	 <td height=\"100\" align=\"left\" valign=\"top\"><table width=\"98%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\
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
	
	[html appendString: [[NSString alloc]initWithFormat:@"http://mobil.immobilienscout24.de/expose/%i",[selectedImmoscoutFlat exposeId]]];

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
	[controller release];	
    [html release];
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
            frame.origin.x = 5;
            [self shareBar].frame = frame;
            
			/*CGRect frame1 = [self exposeActionButton].frame;
			frame1.origin.x = 11;
			[self exposeActionButton].frame = frame1;
			
			CGRect frame2 = [self shareButton].frame;
			frame2.origin.x = 56;
			[self shareButton].frame = frame2;
			
			CGRect frame3 = [self twitterButton].frame;
			frame3.origin.x = 101;
			[self twitterButton].frame = frame3;
			
			CGRect frame4 = [self facebookButton].frame;
			frame4.origin.x = 182;
			[self facebookButton].frame = frame4;
			
			CGRect frame5 = [self mailButton].frame;
			frame5.origin.x = 268;
			[self mailButton].frame = frame5;*/
			
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
            frame.origin.x = 225;
            [self shareBar].frame = frame;
			
			/*CGRect frame1 = [self exposeActionButton].frame;
			frame1.origin.x = 221;
			[self exposeActionButton].frame = frame1;
			
			CGRect frame2 = [self shareButton].frame;
			frame2.origin.x = 266;
			[self shareButton].frame = frame2;
			
			CGRect frame3 = [self twitterButton].frame;
			frame3.origin.x = 321;
			[self twitterButton].frame = frame3;
			
			CGRect frame4 = [self facebookButton].frame;
			frame4.origin.x = 402;
			[self facebookButton].frame = frame4;
			
			CGRect frame5 = [self mailButton].frame;
			frame5.origin.x = 488;
			[self mailButton].frame = frame5;*/
			
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
    [[FacebookManager getInstance] setFacebookActionLink:[[NSString alloc]initWithFormat:@"%@%i",urlIS24MobileExpose,[selectedImmoscoutFlat exposeId]]];
    
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
}



@end
