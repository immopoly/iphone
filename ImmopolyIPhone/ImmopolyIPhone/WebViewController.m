//
//  WebViewController.m
//  Created by Tobias Heine.
//

#import "WebViewController.h"
#import "ImmopolyManager.h"
#import "FlatTakeOverTask.h"
#import "FlatRemoveTask.h"
#import "FacebookManager.h"

@implementation WebViewController

@synthesize webView,activityIndicator,selectedExposeId,selectedImmoscoutFlat, loginCheck,flatActionButton;

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
    
    [[FacebookManager getInstance] set_APP_KEY:@"144949825610311"];
	[[FacebookManager getInstance] set_SECRET_KEY:@"7dab17bab8145e9d973378ea1582d0ca"];
    
    [FacebookManager getInstance].delegate = self;
    
    [flatActionButton setTitle: @"Disabled" forState: UIControlStateDisabled];
    [[self flatActionButton]setEnabled:NO];
    
    NSTimer *rat =[NSTimer scheduledTimerWithTimeInterval:(5) target:self selector:@selector(enableFlatButton:) userInfo:nil repeats:NO]; 
    
}

-(void)enableFlatButton:(NSTimer *)theTimer{
    [[self flatActionButton]setEnabled:YES];
}

-(void)reloadData {
    NSString *urlAddress = [[NSString alloc]initWithFormat:@"http://mobil.immobilienscout24.de/expose/%i",[selectedImmoscoutFlat exposeId]];
	//NSString *urlAddress = @"http://mobil.immobilienscout24.de/expose/";
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
    [urlAddress release];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
    
    if ([[[[ImmopolyManager instance]user]portfolio]containsObject:[self selectedImmoscoutFlat]]) {
        [flatActionButton setTitle: @"Expose abgeben" forState: UIControlStateNormal];
    }else{
        [flatActionButton setTitle: @"Expose übernehmen" forState: UIControlStateNormal];
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

-(IBAction)goBack{
    [self.view removeFromSuperview];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [activityIndicator startAnimating];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
    activityIndicator.hidden=YES;
}

-(IBAction)flatAction{
     
    //FlatTakeOverTask *flatTask = [[FlatTakeOverTask alloc]init];
    //[flatTask takeOverFlat:[self selectedImmoscoutFlat]];
    loginCheck.delegate = self;
    [loginCheck checkUserLogin];
}

-(void) displayUserData {
    
    if ([[[[ImmopolyManager instance]user]portfolio]containsObject:[self selectedImmoscoutFlat]]) {
        
        UIAlertView *removeFlatDialog = [[UIAlertView alloc]initWithTitle:@"Expose abgeben" message:@"Das Abgeben eines Exposes kostet dich eine Strafe. Möchtest du trotzdem fortfahren?" delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Ja", nil];
        
        [removeFlatDialog show];
        [removeFlatDialog release];
        
    }else{
        FlatTakeOverTask *flatTask = [[FlatTakeOverTask alloc]init];
        [flatTask takeOverFlat:[self selectedImmoscoutFlat]];
        [self.view removeFromSuperview];
    }
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
}

-(IBAction)performFacebookPost{
 
}

- (void) facebookStartedLoading{
    
}
- (void) facebookStopedLoading{
    
}

-(IBAction)showActionSheet:(id)sender {

    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Teile diese Wohnung mit Freunden!" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Abbrechen" otherButtonTitles:@"Facebook", @"Twitter", @"Mail", nil];

    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;

    [popupQuery showInView:self.view];

    [popupQuery release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    if (buttonIndex == 1) {

        [[FacebookManager getInstance] beginShare];
        
        //[[FacebookManager getInstance] setFacebookText:@"FacebookText"];
        [[FacebookManager getInstance] setFacebookTitle:@"Immopoly for iPhone"];
        [[FacebookManager getInstance] setFacebookCaption:@"Werde Immobilienhai und Millionär"];
        [[FacebookManager getInstance] setFacebookDescription:@"Immopoly ein Spiel für iPhone & Android"];
        [[FacebookManager getInstance] setFacebookImage:[selectedImmoscoutFlat pictureUrl]];
        [[FacebookManager getInstance] setFacebookLink:@"http://immopoly.appspot.com/"];
        //[[FacebookManager getInstance] setFacebookUserPrompt:@"FacebookPrompt"];
        [[FacebookManager getInstance] setFacebookActionLabel:@"Immobilien Scout 24"];
        [[FacebookManager getInstance] setFacebookActionText:@"Schau dir doch mal die folgende Wohnung an"];
        [[FacebookManager getInstance] setFacebookActionLink:[[NSString alloc]initWithFormat:@"http://mobil.immobilienscout24.de/expose/%i",[selectedImmoscoutFlat exposeId]]];
        
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

-(void)showTweet {
    Class twitterClass = NSClassFromString(@"TWTweetComposeViewController");
    
    if(!twitterClass) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No iOS 5" message:@"You need iOS 5 to use the Twitter function." delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else {
        if(![TWTweetComposeViewController canSendTweet]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Account" message:@"You need Twitter account to use the Twitter function. Please check your phone settings." delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil];
            [alert show];
            [alert release]; 
        }
        else {
            TWTweetComposeViewController *tweetView = [[TWTweetComposeViewController alloc] init];
            [tweetView setInitialText:@"Coole Wohnung! #immopoly"];
            NSString *url = [NSString stringWithFormat:@"http://immobilienscout24.de/expose/%i", [selectedImmoscoutFlat exposeId]];
            
            if(![tweetView addURL:[NSURL URLWithString:url]]) {
                NSLog(@"Unable to add the URL.");
            }
            
            [self presentModalViewController:tweetView animated:YES];
            
        }
    }
}

- (void) showEmail{
    
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
	
	//[html appendString:@"Cor Ideal - Suvinil Cores App"];
	
	
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
    
	[controller setSubject:@"Super Wohnung gefunden"];
	[controller setMessageBody:html isHTML:YES];
	
    if (controller) [self presentModalViewController:controller animated:YES];
	[controller release];	
	
}

- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}



@end
