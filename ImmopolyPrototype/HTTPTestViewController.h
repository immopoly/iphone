//
//  HTTPTestViewController.h
//  ImmopolyPrototype
//
//  Created by Tobias Heine on 11.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTTPTestViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UITextView *jsonResponse;
    IBOutlet UITextField *webAdress;
    
    NSURLConnection *connection;
    NSMutableData *data;
}

- (IBAction)performPost;

@property(nonatomic, retain)IBOutlet UITextView *jsonResponse;
@property(nonatomic, retain)IBOutlet UITextField *webAdress;
@property(nonatomic, retain) NSURLConnection *connection;
@property(nonatomic, retain) NSMutableData *data;

@end
