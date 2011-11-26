//
//  FacebookManager.m
//  FacebookAPI
//
//  Created by Tobias Heine on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookManager.h"

@implementation FacebookManager
@synthesize _session, facebookAlert, usersession, username, post, login, _APP_KEY, _SECRET_KEY, delegate;
@synthesize facebookText, facebookTitle, facebookCaption, facebookImage, facebookLink, facebookUserPrompt, facebookActionLabel, facebookActionText, facebookActionLink, facebookDescription;

static FacebookManager* gInstance = nil;

+ (FacebookManager *) getInstance {
	if (gInstance == nil) {
		gInstance = [[FacebookManager alloc] init];
	}
	
	return gInstance;
}

- (void) beginShare {
	
	loadingVisible = NO;
	
	[self setFacebookText:@" "];
	[self setFacebookTitle:@" "];
	[self setFacebookCaption:@" "];
	[self setFacebookImage:@" "];
	[self setFacebookLink:@" "];
	[self setFacebookUserPrompt:@" "];
	[self setFacebookActionLabel:@" "];
	[self setFacebookActionText:@" "];
	[self setFacebookActionLink:@" "];
	
}

- (void) commitShare {
	
	if (_session == nil){
		_session = [FBSession
								sessionForApplication:_APP_KEY
								secret:_SECRET_KEY delegate:self];		
	}
	
	BOOL shouldLogout = [[NSUserDefaults standardUserDefaults] boolForKey:@"facebook_logout"];
	
	if(shouldLogout) {
		[_session logout];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"facebook_logout"];
	}
	
	BOOL resume = [_session resume];
	if(!resume) {
		NSLog(@"teste");
		self.login = [[[FBLoginDialog alloc] initWithSession: _session] autorelease];
		self.login.delegate = self;
		[login show];
	}
	else {
		if(!loadingVisible) {
			loadingVisible = YES;
			[delegate facebookStartedLoading];
		}
	}
}

- (void)session:(FBSession*)session didLogin:(FBUID)uid {
	self.usersession =session;
	//NSLog(@"User with id %lld logged in.", uid);
	[self getFacebookName];
}

- (void)getFacebookName {
	NSString* fql = [NSString stringWithFormat:
					 @"select uid,name from user where uid == %lld",
					 self.usersession.uid];
	NSDictionary* params =
	[NSDictionary dictionaryWithObject:fql
								forKey:@"query"];
	[[FBRequest requestWithDelegate:self]
	 call:@"facebook.fql.query" params:params];
	self.post=YES;
}

- (void)request:(FBRequest*)request didLoad:(id)result {
	if ([request.method isEqualToString:@"facebook.fql.query"]) {
		NSArray* users = result;
		NSDictionary* user = [users objectAtIndex:0];
		NSString* name = [user objectForKey:@"name"];
        self.username = name;
		
		if (self.post) {
			[self postToWall];
			self.post = NO;
		}
	}
}

- (void)postToWall {
	
	if(loadingVisible) {
		loadingVisible = NO;
		[delegate facebookStopedLoading];
	}
	
	/*NSLog(@"Text: %@", [self facebookText]);
	NSLog(@"Title: %@", [self facebookTitle]);
	NSLog(@"Caption: %@", [self facebookCaption]);
	NSLog(@"Image: %@", [self facebookImage]);
	NSLog(@"Link: %@", [self facebookLink]);
	NSLog(@"UserPrompt: %@", [self facebookUserPrompt]);
	NSLog(@"ActionLabel: %@", [self facebookActionLabel]);
	NSLog(@"ActionText: %@", [self facebookActionText]);
	NSLog(@"ActionLink: %@", [self facebookActionLink]);*/
	
	FBStreamDialog *dialog = [[[FBStreamDialog alloc] init] autorelease];
	dialog.userMessagePrompt = [self facebookUserPrompt];
	dialog.attachment = [NSString stringWithFormat:@"{\"name\":\"%@\",\"href\":\"%@\",\"caption\":\"%@\",\"description\":\"%@\",\"media\":[{\"type\":\"image\",\"src\":\"%@\",\"href\":\"%@\"}],\"properties\":{\"%@\":{\"text\":\"%@\",\"href\":\"%@\"}}}", [self facebookTitle], [self facebookLink], [self facebookCaption], [self facebookDescription], [self facebookImage], [self facebookLink], [self facebookActionLabel], [self facebookActionText], [self facebookActionLink]];
	[dialog show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (void)dialogWillAppear {
	if(loadingVisible) {
		loadingVisible = NO;
		[delegate facebookStopedLoading];
	}
}
/*
- (void)dialogWillDesappear {
	
	//NSLog(@"teste");
	if(loadingVisible) {
		loadingVisible = NO;
		[delegate facebookStopedLoading];
	}
}
*/
- (void)dealloc {
	
	delegate = nil;
	
	[_session release];
	[login release];
	[username release];
	[usersession release];
	[facebookText release];
	[facebookTitle release];
	[facebookCaption release];
	[facebookDescription release];
	[facebookImage release];
	[facebookLink release];
	[facebookUserPrompt release];
	[facebookActionLabel release];
	[facebookActionText release];
	[facebookActionLink release];
	[super dealloc];
}

@end
