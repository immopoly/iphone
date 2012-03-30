//
//  ActionItemManager.m
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 28.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionItemManager.h"
#import "Constants.h"
#import "SpionAction.h"
#import "ImmopolyManager.h"

@implementation ActionItemManager
@synthesize currentItem;

-(void)useCurrentActionItem{
    switch ([[self currentItem] type]) {
        case ACTION_ITEM_SPION:
            [self executeSpionAction];
            
            break;
            
        default:
            break;
    }
}

-(void)executeSpionAction{
    for (ActionItem *item in [[[ImmopolyManager instance]user]actionItems]) {
        if ([item type] == ACTION_ITEM_SPION && [item amount]>0) {
            [item setAmount:([item amount]-1)];
            SpionAction *action = [[SpionAction alloc]init];
            action.delegate = self;
            [action executeAction:[[[ImmopolyManager instance]user]portfolio]];
            
            break;
        }
    }
}

-(void)executedActionWithResult:(_Bool)_result{
    if(_result) {
        UIAlertView *alert;
        alert = [[UIAlertView alloc]initWithTitle:@"Aktion erfolgreich ausgeführt" message:[currentItem text] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}

-(void)placeActionItems{
    for (ActionItem *item in [[[ImmopolyManager instance]user]actionItems]) {
        switch ([item type]) {
            case ACTION_ITEM_SPION:
                //place item on map
                
                break;
                
            default:
                break;
        }
        
    }
}

@end
