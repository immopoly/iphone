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
    NSMutableArray *actionItems;
}

@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *userToken;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, assign) double balance;
@property(nonatomic, assign) int lastProvision;
@property(nonatomic, assign) double lastRent;
@property(nonatomic, assign) int numExposes;
@property(nonatomic, assign) int maxExposes;

@property(nonatomic,strong) NSMutableArray *portfolio;
@property(nonatomic,strong) NSMutableArray *history;
@property(nonatomic,strong) NSMutableArray *badges;
@property(nonatomic,strong) NSMutableArray *actionItems;


@end
