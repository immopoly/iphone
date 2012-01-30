//
//  ShowNextViewDelegate.h
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 13.11.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImmopolyUser.h"

@protocol NotifyViewDelegate <NSObject>

- (void)notifyMyDelegateView;
- (void)closeMyDelegateView;
- (void)notifyMyDelegateViewWithUser:(ImmopolyUser *)user;

@end
