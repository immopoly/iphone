//
//  ActionItemButton.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 28.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionItem.h"

@interface ActionItemButton : UIButton{
    ActionItem *item;
}

@property(nonatomic,retain)ActionItem *item;

@end
