//
//  ActionItemManager.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 28.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionItem.h"
#import "ActionItemDelegate.h"

#define ACTION_ITEM_SPION 1

@interface ActionItemManager : NSObject<ActionItemDelegate>{
    ActionItem *currentItem;
}

-(void)useCurrentActionItem;
-(void)executeSpionAction;
-(void)placeActionItems;

@property(nonatomic,strong) ActionItem *currentItem;

@end
