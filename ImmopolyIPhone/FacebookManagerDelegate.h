//
//  FacebookManagerDelegate.h
//  CoresSuvinil
//
//  Created by Tobias Heine on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FacebookManagerDelegate
- (void) facebookStartedLoading;
- (void) facebookStopedLoading;
@end
