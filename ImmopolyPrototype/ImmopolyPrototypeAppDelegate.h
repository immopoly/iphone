//
//  ImmopolyPrototypeAppDelegate.h
//  ImmopolyPrototype
//
//  Created by Tobias Heine on 10.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImmopolyPrototypeViewController;

@interface ImmopolyPrototypeAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ImmopolyPrototypeViewController *viewController;

@end
