//
//  FacebookManager.h
//  FacebookAPI
//
//  Created by Tobias Heine on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "FBSession.h"
#import "FacebookManagerDelegate.h"

@interface FacebookManager : NSObject <FBSessionDelegate, FBRequestDelegate, FBDialogDelegate> {
	
	NSString* _APP_KEY;
	NSString* _SECRET_KEY;
	
	FBSession *_session;
	FBSession *usersession;
	UIAlertView *facebookAlert;
	NSString *username;
	BOOL post;
	FBLoginDialog* login;
	
	NSString* facebookText;
	NSString* facebookTitle;
	NSString* facebookCaption;
	NSString* facebookDescription;	
	NSString* facebookImage;
	NSString* facebookLink;
	NSString* facebookUserPrompt;
	NSString* facebookActionLabel;
	NSString* facebookActionText;
	NSString* facebookActionLink;
	
	id<FacebookManagerDelegate> __unsafe_unretained delegate;
	BOOL loadingVisible;
}

+ (FacebookManager*) getInstance;
- (void) beginShare;
- (void) commitShare;
- (BOOL) textFieldShouldReturn:(UITextField *)textField;
- (void) getFacebookName;
- (void) postToWall;

@property (nonatomic,strong) FBSession *_session;
@property (nonatomic,strong) UIAlertView *facebookAlert;
@property (nonatomic,strong) FBSession *usersession;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,assign) BOOL post;
@property (nonatomic,strong) FBLoginDialog* login; 

@property (nonatomic, strong) NSString* _APP_KEY;
@property (nonatomic, strong) NSString* _SECRET_KEY;

@property(nonatomic, strong) NSString* facebookText;
@property(nonatomic, strong) NSString* facebookTitle;
@property(nonatomic, strong) NSString* facebookCaption;
@property(nonatomic, strong) NSString* facebookDescription;
@property(nonatomic, strong) NSString* facebookImage;
@property(nonatomic, strong) NSString* facebookLink;
@property(nonatomic, strong) NSString* facebookUserPrompt;
@property(nonatomic, strong) NSString* facebookActionLabel;
@property(nonatomic, strong) NSString* facebookActionText;
@property(nonatomic, strong) NSString* facebookActionLink;

@property (nonatomic, unsafe_unretained) id<FacebookManagerDelegate> delegate;

@end
