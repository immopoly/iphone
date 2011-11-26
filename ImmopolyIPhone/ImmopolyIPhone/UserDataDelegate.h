//
//  UserDataDelegate.h
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 11.11.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserDataDelegate <NSObject>

-(void) displayUserData;
-(void) stopSpinnerAnimation;

@end
