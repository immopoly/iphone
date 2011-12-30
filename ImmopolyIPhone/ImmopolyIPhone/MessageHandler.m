//
//  MessageHandler.m
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 02.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageHandler.h"
#import "Constants.h"

@implementation MessageHandler

+ (NSString *)giveErrorMsg:(NSError*)error {
    
    int errorCode = [error code];
    NSString *errorMsg;
    
    switch (errorCode) {
        case 43:
            //missing username
            errorMsg = [[[NSString alloc]initWithString:errorMissingUsername] autorelease];
            break;
        case 44:
            //missing password
            errorMsg = [[[NSString alloc]initWithString:errorMissingPassword]autorelease ];
            break;
        case 45:
            //username already taken
            errorMsg = [[[NSString alloc]initWithString:errorUsernameAlreadyInUse] autorelease];
            break;
        case 51:    
            //username or password not found
            errorMsg = [[[NSString alloc]initWithString:errorUsernameOrUsernameIncorrect] autorelease];
            break;
        case 61:
            //missing token
            errorMsg = [[[NSString alloc]initWithString:errorTokenNotFound] autorelease];
            break;
        case 62:
            //token not found
            errorMsg = [[[NSString alloc]initWithString:errorTokenNotFound] autorelease];
            break;
        case 101:    
            //could not login user or add expose
            errorMsg = [[[NSString alloc]initWithString:errorTryAgainLater] autorelease];
            break;
        case 201:
            errorMsg = [[[NSString alloc]initWithString:errorAlreadyYourExpose] autorelease];
            break;
        case 302:
            errorMsg = [[[NSString alloc]initWithString:errorExposeHasNoRent] autorelease];
            break;
        case 301:
            errorMsg = [[[NSString alloc] initWithString:errorExposeNotExists] autorelease];
            break;
        default:
            errorMsg = [[[NSString alloc] initWithFormat: @"%@", [[error userInfo] objectForKey: @"ErrorMessage"]] autorelease];
            break;
    }
    return errorMsg;
}

@end
