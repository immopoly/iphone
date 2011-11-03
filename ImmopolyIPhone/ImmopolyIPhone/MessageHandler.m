//
//  MessageHandler.m
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 02.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageHandler.h"

@implementation MessageHandler

+ (NSString *)giveErrorMsg:(int)errorCode{
    NSString *errorMsg;
    
    switch (errorCode) {
        case 61:
            //missing token
            errorMsg = [[NSString alloc]initWithString:@"Ups, da ging etwas schief. Probiere es später noch einmal!"];
            break;

        case 62:
            //token not found
            errorMsg = [[NSString alloc]initWithString:@"Ups, da ging etwas schief. Probiere es später noch einmal!"];
            break;
        
        case 201:
            errorMsg = [[NSString alloc]initWithString:@"Dieses Expose gehört dir schon!"];
            break;

        case 302:
            errorMsg = [[NSString alloc]initWithString:@"Das Expose hat keinen Wert für Kaltmiete, sie kann nicht übernommen werden."];
            break;

        case 301:
            errorMsg = [[NSString alloc]initWithString:@"Das Expose gibt es nicht"];
            break;
            
        case 101:
            errorMsg = [[NSString alloc]initWithString:@"Das Expose konnte nicht hinzugefügt werden!"];
            break;
            
            
        default:
            break;
    }
    
    return errorMsg;
}

@end
