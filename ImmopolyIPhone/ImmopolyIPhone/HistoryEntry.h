//
//  HistoryEntry.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 31.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//



@interface HistoryEntry : NSObject{
    NSString *histText;
    long long time;
    int type;
    int type2;
}

@property(nonatomic, retain) NSString *histText;
@property(nonatomic, assign) long long time;
@property(nonatomic, assign) int type;
@property(nonatomic, assign) int type2;
@end
