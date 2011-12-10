//
//  Constants.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 10.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

extern NSString* const errorMissingUsername;
extern NSString* const errorMissingPassword;
extern NSString* const errorUsernameAlreadyInUse;
extern NSString* const errorUsernameOrUsernameIncorrect;
extern NSString* const errorTryAgainLater;
extern NSString* const errorAlreadyYourExpose;
extern NSString* const errorExposeHasNoRent;
extern NSString* const errorExposeNotExists;

extern NSString* const urlIS24API;
extern NSString* const urlIS24MobileExpose;
extern NSString* const urlImmopolyUser;
extern NSString* const urlImmopolyPortfolio;

extern NSString* const alertRegisterWrongInput;
extern NSString* const alertRegisterSuccessful;
extern NSString* const alertExposeGiveAwayWarning;

extern NSString* const sharingActionSheetTitle;

extern NSString* const sharingFacebookTitle;
extern NSString* const sharingFacebookCaption;
extern NSString* const sharingFacebookDescription;
extern NSString* const sharingFacebookLink;
extern NSString* const sharingFacebookActionLabel;
extern NSString* const sharingFacebookActionText;

extern NSString* const sharingTwitterAPINotAvailableAlertTitle;
extern NSString* const sharingTwitterAPINotAvailableAlertMessage;
extern NSString* const sharingTwitterNoAccountAlertTitle;
extern NSString* const sharingTwitterNoAccountAlertMessage;
extern NSString* const sharingTwitterMessage;

extern NSString* const sharingMailSubject;

@end
