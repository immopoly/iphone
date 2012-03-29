//
//  ActionItemDelegate.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 28.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ActionItemDelegate <NSObject>

- (void)executedActionWithResult:(bool)_result;

@end
