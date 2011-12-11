//
//  UserBadge.h
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 09.12.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBadge : NSObject {
    
    int amount;
    NSString *text;
    long long time;
    int type;
    NSString *url;
}

@property(nonatomic, assign) int amount;
@property(nonatomic, retain) NSString *text;
@property(nonatomic, assign) long long time;
@property(nonatomic, assign) int type;
@property(nonatomic, retain) NSString *url;

@end
