//
//  PortfolioViewController.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 29.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "UserDataDelegate.h"
//#import "LoginCheck.h"
#import "Flat.h"
#import "WebViewController.h"
#import "AsynchronousImageView.h"
#import "AbstractMapViewController.h"
#import "PortfolioDelegate.h"

#define METERS_PER_MILE 5000.00
#define ANNO_WIDTH 40
#define ANNO_HEIGHT 51

@interface PortfolioViewController : AbstractMapViewController <UITableViewDataSource, UITableViewDelegate, UserDataDelegate, NotifyViewDelegate,PortfolioDelegate> {
        BOOL hasPortfolioChanged;
}

@property(nonatomic, assign) BOOL hasPortfolioChanged;

@end
