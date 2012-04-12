//
//  ActionItem.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 25.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScrollViewItem.h"

@interface ActionItem : ScrollViewItem {
    int userId;
}

@property(nonatomic, assign) int userId;

@end
