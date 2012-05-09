//
//  NewsViewController.h
//  ImmopolyIPhone
//
//  Created by Tobias Heine on 09.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"

@interface NewsViewController : AbstractViewController{
    IBOutlet UIWebView *newsList;
}


@property(nonatomic,retain)IBOutlet UIWebView *newsList;

@end
