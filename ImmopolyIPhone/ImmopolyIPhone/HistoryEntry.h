//
//  HistoryEntry.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 31.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#define TYPE_EXPOSE_ADDED 1
#define TYPE_EXPOSE_SOLD 2
#define TYPE_EXPOSE_MONOPOLY_POSITIVE 3
#define TYPE_EXPOSE_MONOPOLY_NEGATIVE 4
#define TYPE_DAILY_PROVISION 5
#define TYPE_DAILY_RENT 6

@interface HistoryEntry : NSObject {
    NSString *histText;
    long long time;
    int type;
    int type2;
    int exposeId;
    bool isSharingActivated;
}

@property(nonatomic, retain) NSString *histText;
@property(nonatomic, assign) long long time;
@property(nonatomic, assign) int type;
@property(nonatomic, assign) int type2;
@property(nonatomic, assign) int exposeId;
@property(nonatomic, assign) bool isSharingActivated;
@end
