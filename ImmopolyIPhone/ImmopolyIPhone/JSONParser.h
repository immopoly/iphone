//
//  JSONParser.h
//  ImmopolyPrototype
//
//  Created by Tobias Buchholz on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationDelegate.h"
#import "HistoryEntry.h"
#import "ImmopolyUser.h"

@interface JSONParser : NSObject {
    id<LocationDelegate>__unsafe_unretained delegate;
}

@property(nonatomic, unsafe_unretained) id<LocationDelegate>delegate;

+ (ImmopolyUser *)parseUserData:(NSString *)jsonString:(NSError **) err;
+ (NSMutableArray *)parseFlatData:(NSString *)jsonString:(NSError **) err;
+ (HistoryEntry *)parseHistoryEntry:(NSString *)jsonString:(NSError **) err;
+ (NSArray *)parseHistoryEntries:(NSString *)jsonString:(NSError **) err;
+ (ImmopolyUser *)parsePublicUserData:(NSString *)jsonString:(NSError **)err;
+ (NSMutableArray *)parseExposes:(NSString *)jsonString:(NSError **)err;

@end