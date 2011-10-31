//
//  FlatTakeOverTask.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 31.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//



@interface FlatTakeOverTask : NSObject{
    NSURLConnection *connection;
    NSMutableData *data;
}

@property(nonatomic, retain) NSURLConnection *connection;
@property(nonatomic, retain) NSMutableData *data;

-(void)takeOverFlat:(int)exposeId;

@end
