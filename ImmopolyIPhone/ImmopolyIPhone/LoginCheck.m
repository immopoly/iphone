//
//  LoginCheck.m
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 13.11.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import "LoginCheck.h"
#import "ImmopolyManager.h"
#import "UserLoginTask.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "WebViewController.h"

@implementation LoginCheck

@synthesize delegate;


- (void)checkUserLogin {
    
    //For tests
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL automaticLogin = [defaults boolForKey:@"saveToken"];
    
    //if user is logged in show user profile data
    if([[ImmopolyManager instance] loginSuccessful]){
        [self notifyMyDelegateView];
    }
    else if([[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] != nil && automaticLogin) {
        //get user token
        NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
        //login with token
        UserLoginTask *loader = [[[UserLoginTask alloc] init] autorelease];
        loader.delegate = self;
        [loader performLoginWithToken: userToken];
        //[loader autorelease];
    }
    //otherwise display login view
    else {
        [self showLoginViewController];
    }
}

- (void)showLoginViewController {
    //in tabbar
    AppDelegate *appDelegate = [(AppDelegate *)[UIApplication sharedApplication] delegate];
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    loginVC.delegate = self;
    
    // preperations for login at webviewController
    int selIndex = [[appDelegate tabBarController] selectedIndex];
    UIViewController *vc = [[[appDelegate tabBarController] viewControllers] objectAtIndex:selIndex];
    WebViewController *webviewController = (WebViewController *)[vc modalViewController]; 
    
    // checks whether the viewController on top is webviewController or not
    if(webviewController != nil && [webviewController isKindOfClass:[WebViewController class]]) {
        [webviewController presentModalViewController:loginVC animated:YES]; 
    } else {
        [[appDelegate tabBarController] presentModalViewController: loginVC animated: YES];  
    }
    [loginVC release];
}

- (void)loginWithResult:(BOOL)_result {
    if(_result) {
        [delegate performActionAfterLoginCheck];
        
        //[self notifyMyDelegateView];
    }
    else {
        [delegate stopSpinnerAnimation];
        [self showLoginViewController];
        /*
        AppDelegate *appDelegate = [(AppDelegate *)[UIApplication sharedApplication] delegate];
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        loginVC.delegate = self;
        [[appDelegate tabBarController] presentModalViewController: loginVC animated: YES];
        [loginVC release];
        */
    }
}

- (void)notifyMyDelegateView {
    [delegate performActionAfterLoginCheck];
}

- (void)closeMyDelegateView {
    [delegate stopSpinnerAnimation];
    AppDelegate *appDelegate = [(AppDelegate *)[UIApplication sharedApplication] delegate];
    if(![delegate isKindOfClass: [WebViewController class]]) {
        //show map
        [[appDelegate tabBarController] setSelectedIndex:2];
    }
}

@end
