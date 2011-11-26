//
//  MessageHandler.m
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 02.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageHandler.h"

@implementation MessageHandler

+ (NSString *)giveErrorMsg:(NSError*) error {
    
    int errorCode = [error code];
    NSString *errorMsg;
    
    switch (errorCode) {
        case 43:
            //missing username
            errorMsg = [[NSString alloc]initWithString:@"Sorry, der Username fehlt."];
            break;
        case 44:
            //missing password
            errorMsg = [[NSString alloc]initWithString:@"Sorry, das Passwort fehlt."];
            break;
        case 45:
            //username already taken
            errorMsg = [[NSString alloc]initWithString:@"Sorry, dieser Name ist leider schon vergeben."];
            break;
        case 51:    
            //username or password not found
            errorMsg = [[NSString alloc]initWithString:@"Sorry, der Username oder das Passwort ist falsch."];
            break;
        case 61:
            //missing token
            errorMsg = [[NSString alloc]initWithString:@"Ups, da ging etwas schief. Probiere es später noch einmal!"];
            break;
        case 62:
            //token not found
            errorMsg = [[NSString alloc]initWithString:@"Ups, da ging etwas schief. Probiere es später noch einmal!"];
            break;
        case 101:    
            //could not login user or add expose
            errorMsg = [[NSString alloc]initWithString:@"Ups, da ging etwas schief. Probiere es später noch einmal!"];
            break;
        case 201:
            errorMsg = [[NSString alloc]initWithString:@"Dieses Expose gehört dir schon!"];
            break;
        case 302:
            errorMsg = [[NSString alloc]initWithString:@"Das Expose hat keinen Wert für Kaltmiete, sie kann nicht übernommen werden."];
            break;
        case 301:
            errorMsg = [[NSString alloc] initWithString:@"Das Expose gibt es nicht"];
            break;
        default:
            errorMsg = [[NSString alloc] initWithFormat: @"%@", [[error userInfo] objectForKey: @"ErrorMessage"] ];
            break;
    }
    return errorMsg;
}

@end
