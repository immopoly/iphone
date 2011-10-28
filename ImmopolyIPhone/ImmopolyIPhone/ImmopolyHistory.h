//
//  ImmopolyHistory.h
//  ImmopolyPrototype
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

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
