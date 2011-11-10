//
//  ImmopolyHistory.h
//  ImmopolyPrototype
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define TYPE_EXPOSE_ADDED 1
#define TYPE_EXPOSE_SOLD 2
#define TYPE_EXPOSE_MONOPOLY_POSITIVE 3
#define TYPE_EXPOSE_MONOPOLY_NEGATIVE 4
#define TYPE_DAILY_PROVISION 5
#define TYPE_DAILY_RENT 6

@interface ImmopolyHistory : NSObject {
    
    NSString *text;
    long time;
    int type;
    double amount;
    
}

@property(nonatomic, retain) NSString *text;
@property(nonatomic, assign) long time;
@property(nonatomic, assign) int type;
@property(nonatomic, assign) double amount;

@end
