//
//  PortfolioTask.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 07.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotifyViewDelegate.h"

@interface PortfolioTask : NSObject{
    NSURLConnection *connection;
    NSMutableData *data;
    id<NotifyViewDelegate>__unsafe_unretained delegate;
}

@property(nonatomic, strong) NSURLConnection *connection;
@property(nonatomic, strong) NSMutableData *data;
@property(nonatomic, unsafe_unretained) id<NotifyViewDelegate>delegate;

- (void)refreshPortolio;



@end
