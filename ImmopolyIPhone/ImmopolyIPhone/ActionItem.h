//
//  ActionItem.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 25.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionItem : NSObject{
    int amount;
    NSString *text;
    long long time;
    int userId;
    int type;
    NSString *url;
}

@property(nonatomic, assign) int amount;
@property(nonatomic, retain) NSString *text;
@property(nonatomic, assign) long long time;
@property(nonatomic, assign) int userId;
@property(nonatomic, assign) int type;
@property(nonatomic, retain) NSString *url;

@end
