//
//  LoginCheck.h
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 13.11.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginDelegate.h"
#import "UserDataDelegate.h"
#import "NotifyViewDelegate.h"

@interface LoginCheck : NSObject <LoginDelegate, NotifyViewDelegate> {
    id<UserDataDelegate> __unsafe_unretained delegate;
}

@property (nonatomic, unsafe_unretained) id<UserDataDelegate> delegate;

- (void)checkUserLogin;
- (void)showLoginViewController;

@end
