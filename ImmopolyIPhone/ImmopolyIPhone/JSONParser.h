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
    id<LocationDelegate>delegate;
}

@property(nonatomic, assign) id<LocationDelegate>delegate;

+ (ImmopolyUser *)parseUserData:(NSString *)jsonString:(NSError **) err;
+ (NSMutableArray *)parseFlatData:(NSString *)jsonString:(NSError **) err;
+ (HistoryEntry *)parseHistoryEntry:(NSString *)jsonString:(NSError **) err;
+ (void) throwException:(NSError **)err atDomain:(NSString *) domainName withJsonResult:(NSDictionary *) results;

@end