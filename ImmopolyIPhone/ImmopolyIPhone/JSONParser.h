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

@interface JSONParser : NSObject {
    id<LocationDelegate>delegate;
}

@property(nonatomic, assign) id<LocationDelegate>delegate;

+ (void)parseUserData:(NSString *)jsonString;
+ (void)parseFlatData:(NSString *)jsonString;
+ (HistoryEntry *)parseHistoryEntry:(NSString *)jsonString:(NSError **) err;

@end