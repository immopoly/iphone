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
            errorMsg = [[NSString alloc]initWithString:@"missing token"];
            break;

        case 62:
            errorMsg = [[NSString alloc]initWithString:@"token not found"];
            break;
        
        case 201:
            errorMsg = [[NSString alloc]initWithString:@"Dieses Expose gehört dir schon!"];
            break;

        case 302:
            errorMsg = [[NSString alloc]initWithString:@"Expose hat keinen Wert für Kaltmiete, sie kann nicht übernommen werden."];
            break;

        case 301:
            errorMsg = [[NSString alloc]initWithString:@"Das Expose gibt es nicht"];
            break;
            
        case 101:
            errorMsg = [[NSString alloc]initWithString:@"Expose konnte nicht hinzugefügt werden!"];
            break;
            
            
        default:
            break;
    }
    
    return errorMsg;
}

@end
