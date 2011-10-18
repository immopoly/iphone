//
//  User.h
//  ImmopolyPrototype
//
//  Created by Tobias Heine on 10.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject{
    NSString *userName;
    NSString *token;
    NSMutableArray *portfolio;
}

@property(nonatomic,retain) NSString *userName;
@property(nonatomic,retain) NSString *token;
@property(nonatomic,retain) NSMutableArray *portfolio;

+ (User *)instance;


@end
