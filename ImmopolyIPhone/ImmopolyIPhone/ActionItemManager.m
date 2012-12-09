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
#import "AppDelegate.h"
#import "ImmopolyMapViewController.h"
#import "ActionItemButton.h"
#import "SpionAction.h"

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
        if ([item type] == ACTION_ITEM_SPION ) {
            
            SpionAction *action = [[SpionAction alloc]init];
            action.delegate = self;
            [action executeAction:[[ImmopolyManager instance]immoScoutFlats]];
            
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
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        ImmopolyMapViewController *mapVC = NULL;
        ActionItemButton *button = NULL;
        switch ([item type]) {
            case ACTION_ITEM_SPION:
                //place item on map
                mapVC = [[[delegate tabBarController]viewControllers]objectAtIndex:2];

                button = [[ActionItemButton alloc]initWithActionItem:item];
                [button setTag:[item type]];
                [button addTarget:mapVC action:@selector(performUserAction:) forControlEvents:UIControlEventTouchUpInside];
                [button setFrame:CGRectMake(200, 290, 50, 50)];
                [[mapVC view]addSubview:button];
                [[mapVC view]bringSubviewToFront:button];
                break;
                
            default:
                break;
        }
        
    }
}

@end
