//
//  FacebookManager.h
//  FacebookAPI
//
//  Created by Roger Sanoli on 7/11/11.
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
	
	id<FacebookManagerDelegate> delegate;
	BOOL loadingVisible;
}

+ (FacebookManager*) getInstance;
- (void) beginShare;
- (void) commitShare;
- (BOOL) textFieldShouldReturn:(UITextField *)textField;
- (void) getFacebookName;
- (void) postToWall;

@property (nonatomic,retain) FBSession *_session;
@property (nonatomic,retain) UIAlertView *facebookAlert;
@property (nonatomic,retain) FBSession *usersession;
@property (nonatomic,retain) NSString *username;
@property (nonatomic,assign) BOOL post;
@property (nonatomic,retain) FBLoginDialog* login; 

@property (nonatomic, retain) NSString* _APP_KEY;
@property (nonatomic, retain) NSString* _SECRET_KEY;

@property(nonatomic, retain) NSString* facebookText;
@property(nonatomic, retain) NSString* facebookTitle;
@property(nonatomic, retain) NSString* facebookCaption;
@property(nonatomic, retain) NSString* facebookDescription;
@property(nonatomic, retain) NSString* facebookImage;
@property(nonatomic, retain) NSString* facebookLink;
@property(nonatomic, retain) NSString* facebookUserPrompt;
@property(nonatomic, retain) NSString* facebookActionLabel;
@property(nonatomic, retain) NSString* facebookActionText;
@property(nonatomic, retain) NSString* facebookActionLink;

@property (nonatomic, assign) id<FacebookManagerDelegate> delegate;

@end
