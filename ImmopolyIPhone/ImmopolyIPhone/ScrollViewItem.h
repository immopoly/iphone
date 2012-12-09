//
//  ScrollViewItem.h
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 30.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollViewItem : NSObject {
    
    int amount;
    NSString *text;
    long long time;
    int type;
    NSString *url;
}

@property(nonatomic, assign) int amount;
@property(nonatomic, strong) NSString *text;
@property(nonatomic, assign) long long time;
@property(nonatomic, assign) int type;
@property(nonatomic, strong) NSString *url;

@end
