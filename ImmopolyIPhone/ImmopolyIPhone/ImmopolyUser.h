//
//  ImmopolyUser.h
//  ImmopolyPrototype
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define sPREF_USER "user"
#define sPREF_TOKEN "user_token"

@interface ImmopolyUser : NSObject {
    NSString *userName;
    NSString *userToken;
    NSString *email;
    
    double balance;
    int lastProvision;
    double lastRent;
    int numExposes;
    int maxExposes;
    
    NSMutableArray *portfolio;
    NSMutableArray *history;
    NSMutableArray *badges;
}

@property(nonatomic, retain) NSString *userName;
@property(nonatomic, retain) NSString *userToken;
@property(nonatomic, retain) NSString *email;
@property(nonatomic, assign) double balance;
@property(nonatomic, assign) int lastProvision;
@property(nonatomic, assign) double lastRent;
@property(nonatomic, assign) int numExposes;
@property(nonatomic, assign) int maxExposes;

@property(nonatomic,retain) NSMutableArray *portfolio;
@property(nonatomic,retain) NSMutableArray *history;
@property(nonatomic,retain) NSMutableArray *badges;


@end
