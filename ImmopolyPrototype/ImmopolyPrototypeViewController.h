//
//  ImmopolyPrototypeViewController.h
//  ImmopolyPrototype
//
//  Created by Tobias Heine on 10.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPTestViewController.h"

@interface ImmopolyPrototypeViewController : UIViewController{
    IBOutlet UITextField *userName;
    IBOutlet UITextField *password;
    
    NSURLConnection *connection;
    NSMutableData *data;
    
    HTTPTestViewController *testVC;
    
}

- (IBAction) performLogin;

@property(nonatomic, retain)IBOutlet UITextField *userName;
@property(nonatomic, retain)IBOutlet UITextField *password;

@property(nonatomic, retain) NSURLConnection *connection;
@property(nonatomic, retain) NSMutableData *data;

@property(nonatomic, retain) HTTPTestViewController *testVC;

@end
